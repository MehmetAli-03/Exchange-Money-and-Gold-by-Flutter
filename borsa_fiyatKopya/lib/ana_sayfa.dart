import 'package:flutter/material.dart';
import 'package:borsa_fiyat/altin_Api.dart';
import 'islem.dart';
import 'kur_screen2.dart';
import 'gold_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AltinFiyati> _altinList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGoldPrices();
  }

  Future<void> _fetchGoldPrices() async {
    try {
      _altinList = await AltinApi().getAltinFiyati();
    } catch (e) {
      print("Hata oluştu: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = Color(0xFF24268D); // Harem uygulamasının rengi

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HAREM',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
        ),
        backgroundColor: themeColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: themeColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton('Altın', Icons.attach_money, themeColor, () {}),
                _buildCategoryButton('Döviz', Icons.currency_exchange, themeColor, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const KurScreen()),
                  );
                }),
                _buildCategoryButton('İşlem', Icons.swap_horiz, themeColor, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  islemSayfasi()),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'Altın Türü',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Alış',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Satış',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: _altinList.length,
                      itemBuilder: (context, index) {
                        var altin = _altinList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      altin.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${altin.buy.toStringAsFixed(2)}₺',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${altin.sell.toStringAsFixed(2)}₺',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, IconData icon, Color? color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
