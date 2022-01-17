import 'package:flutter/material.dart';

class GridInCard extends StatelessWidget {
  const GridInCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardの中でGrid表示'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            SizedBox(
              width: 360,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 308,
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (var i = 0; i < 6; i++)
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.amber,
                              ),
                          ],
                        ),
                      ),
                      const Text(
                        'むずいね',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 360,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 308,
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (var i = 0; i < 6; i++)
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.amber,
                              ),
                          ],
                        ),
                      ),
                      const Text(
                        'むずいね',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 360,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 308,
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            for (var i = 0; i < 6; i++)
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.amber,
                              ),
                          ],
                        ),
                      ),
                      const Text(
                        'むずいね',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
