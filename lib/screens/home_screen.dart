import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/providers/forecast_provider.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/responsive.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var data = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: primaryColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: R.sh(100, context),
        title: data.when(
          data: (data) {
            if (data == null) {
              return null;
            }
            if (data.error != null) {
              return null;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Today,${DateFormat("hh:mm").format(DateFormat("yyyy-MM-dd hh:mm").parse(data.location!.localtime!))}',
                        style: TextStyle(
                          fontSize: R.sw(20, context),
                        )),
                    SizedBox(
                      width: R.sw(375, context) / 2 - 30,
                      child: Text(
                        data.location!.name.toString(),
                        style: TextStyle(
                          fontSize: R.sw(28, context),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: R.sw(180, context),
                  height: R.sh(50, context),
                  child: TextField(
                    cursorColor: secondaryColor,
                    controller: ref.watch(textEditingControllerProvider),
                    decoration: InputDecoration(
                      hintText: 'Search places',
                      hintStyle: const TextStyle(height: 1),
                      suffixIcon: IconButton(
                          onPressed: () {
                            ref.invalidate(weatherProvider);
                            Future.delayed(const Duration(milliseconds: 100))
                                .then((value) => ref
                                    .watch(textEditingControllerProvider)
                                    .clear());
                          },
                          icon: const Icon(
                            Icons.search,
                            color: secondaryColor,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: secondaryColor,
                          ),
                          borderRadius:
                              BorderRadius.circular(R.sw(12, context))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: secondaryColor,
                          ),
                          borderRadius:
                              BorderRadius.circular(R.sw(12, context))),
                    ),
                  ),
                )
              ],
            );
          },
          error: (error, stackTrace) => Center(
            child: Text('error:$error'),
          ),
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      body: data.when(
        data: (data) {
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (data.error != null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text('Error: ${data.error!.message}'),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () {
                    ref.invalidate(weatherProvider);
                  },
                  child: const Text('Go Back'),
                ),
              ],
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: R.sh(10, context),
                ),
                Center(
                  child: SizedBox(
                    height: R.sh(230, context),
                    child: CachedNetworkImage(
                      imageUrl: 'http:${data.current!.condition!.icon}',
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: R.sh(10, context),
                ),
                Text(
                  data.current!.condition!.text.toString(),
                  style: TextStyle(
                      fontSize: R.sw(30, context), fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: R.sh(30, context),
                ),
                SizedBox(
                  height: R.sh(70, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('Wind',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: R.sw(18, context))),
                          Text(data.current!.windDegree!.toString(),
                              style: TextStyle(
                                  fontSize: R.sw(30, context),
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor)),
                        ],
                      ),
                      SizedBox(
                        width: R.sw(14, context),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        indent: R.sw(6, context),
                        endIndent: R.sw(6, context),
                      ),
                      SizedBox(
                        width: R.sw(14, context),
                      ),
                      Column(
                        children: [
                          Text('Temp °C',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: R.sw(18, context))),
                          Text(
                            data.current!.tempC!.toString(),
                            style: TextStyle(
                                fontSize: R.sw(30, context),
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          )
                        ],
                      ),
                      SizedBox(
                        width: R.sw(14, context),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        indent: R.sw(6, context),
                        endIndent: R.sw(6, context),
                      ),
                      SizedBox(
                        width: R.sw(14, context),
                      ),
                      Column(
                        children: [
                          Text(
                            'Humidity',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: R.sw(18, context)),
                          ),
                          Text(
                            data.current!.humidity!.toString(),
                            style: TextStyle(
                                fontSize: R.sw(30, context),
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text("error occured $error"),
        ),
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: data.when(
        data: (data) {
          if (data == null) {
            return null;
          }
          if (data.error != null) {
            return null;
          }
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: R.sw(20, context), vertical: R.sw(20, context)),
            height: R.sh(270, context),
            width: R.sw(375, context),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(R.sw(30, context)),
                    topRight: Radius.circular(R.sw(30, context)))),
            child: Column(
              children: [
                Text(
                  'Next ${data.forecast!.forecastday!.length} days',
                  style: TextStyle(
                      color: tertiaryColor,
                      fontSize: R.sw(22, context),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: R.sh(30, context),
                ),
                SizedBox(
                  height: R.sh(160, context),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      width: R.sw(10, context),
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: data.forecast!.forecastday!.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: R.sw(90, context),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(130, 61, 72, 90),
                            borderRadius:
                                BorderRadius.circular(R.sw(16, context))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              DateFormat("dd").format(
                                  data.forecast!.forecastday![index].date!),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: tertiaryColor,
                                  fontSize: R.sw(18, context)),
                            ),
                            Container(
                              height: R.sh(50, context),
                              width: R.sw(50, context),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'http:${data.forecast!.forecastday![index].day!.condition!.icon}',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                                '${data.forecast!.forecastday![index].day!.avgtempC}°C',
                                style: TextStyle(
                                    fontSize: R.sw(18, context),
                                    fontWeight: FontWeight.bold,
                                    color: tertiaryColor)),
                            Text(
                                textAlign: TextAlign.center,
                                data.forecast!.forecastday![index].day!
                                    .condition!.text
                                    .toString(),
                                style: const TextStyle(color: tertiaryColor)),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
        error: (error, stackTrace) => const Center(),
        loading: () => const Center(),
      ),
    );
  }
}
