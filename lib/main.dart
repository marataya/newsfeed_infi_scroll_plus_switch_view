import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lorem_gen/lorem_gen.dart';
import 'package:newsfeed_infi_scroll_plus_switch_view/item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Truest News Network',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        useMaterial3: true,
        // colorScheme: ColorScheme.fromSeed(seedColor: HexColor('#ffabff')),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  var items = <MessageItem>[];
  bool loading = false, allLoaded = false;
  var _viewType = 'list';

  mockFetch() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<MessageItem> newData = items.length >= 1000
        ? []
        : List<MessageItem>.generate(20,
            (index) => MessageItem(Lorem.word(numWords: 4), Lorem.sentence()));
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        print('NEW DATA CALL');
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Truest News Network Latest News',
              style: TextStyle(fontSize: 18, color: HexColor('#f8f9fa'))),
          backgroundColor: HexColor('#183269'),
          actions: [
            IconButton(
              icon: Icon(_viewType == 'list' ? Icons.grid_on : Icons.view_list),
              color: HexColor('#f8f9fa'),
              onPressed: () {
                if (_viewType == 'list') {
                  // _crossAxisCount = 2;
                  // _aspectRatio = 1.5;
                  _viewType = 'grid';
                } else {
                  // _crossAxisCount = 1;
                  // _aspectRatio = 5;
                  _viewType = 'list';
                }
                setState(() {});
              },
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (items.isNotEmpty) {
              if (_viewType == 'list') {
                return Stack(children: [
                  ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if (index < items.length) {
                          final item = items[index];
                          return ListTile(
                            title: item.buildTitle(context),
                            subtitle: item.buildSubtitle(context),
                          );
                        } else {
                          return SizedBox(
                            width: constraints.maxWidth,
                            height: 50,
                            child: const Center(
                              child: Text('No more news today'),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1);
                      },
                      itemCount: items.length + (allLoaded ? 1 : 0)),
                  if (loading) ...[
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: SizedBox(
                            height: 80,
                            width: constraints.maxWidth,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            )))
                  ]
                ]);
              } else {
                return Stack(children: [
                  Container(
                    height: constraints.maxHeight,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (index < items.length) {
                            final item = items[index];
                            return ListTile(
                              title: item.buildTitle(context),
                              subtitle: item.buildSubtitle(context),
                            );
                          } else {
                            return SizedBox(
                              width: constraints.maxWidth,
                              height: 50,
                              child: const Center(
                                child: Text('No more news today'),
                              ),
                            );
                          }
                        },
                        itemCount: items.length + (allLoaded ? 1 : 0)),
                  ),
                  if (loading) ...[
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: SizedBox(
                            height: 80,
                            width: constraints.maxWidth,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            )))
                  ]
                ]);
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
