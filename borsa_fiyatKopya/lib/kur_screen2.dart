import 'package:borsa_fiyat/ana_sayfa.dart';
import 'package:flutter/material.dart';
import 'islem2.dart';
import 'kur_api.dart';
import 'kur_screen.dart';

class KurScreen extends StatefulWidget {
  const KurScreen({super.key});

  @override
  State<KurScreen> createState() => _KurScreenState();
}

class _KurScreenState extends State<KurScreen> {
  List<kurFiyatlari> _kurList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKurPrices();
  }

  Future<void> _fetchKurPrices() async {
    try {
      _kurList = await kurApi().getkurFiyatlari();
    } catch (e) {
      print("Hata oluştu: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = Color(0xFF24268D);
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
                _buildCategoryButton('Altın', themeColor, Icons.attach_money, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  HomePage()),
                  );
                }),
                _buildCategoryButton('Döviz', themeColor, Icons.currency_exchange, () {}),
                _buildCategoryButton('İşlem', themeColor, Icons.swap_horiz, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  islemSayfasi2()),
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
                            'Döviz Türü',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'TL Karşılığı',
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
                      itemCount: _kurList.length,
                      itemBuilder: (context, index) {
                        var kur = _kurList[index];
                        double tersKur = 1 / kur.rate; // 1 birim döviz kaç TL eder?

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
                                      "1 ${kur.name} = ",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${tersKur.toStringAsFixed(2)} TL",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
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

  Widget _buildCategoryButton(String title, Color color, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 24),
        label: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
