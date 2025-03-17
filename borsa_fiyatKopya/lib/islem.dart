import 'package:flutter/material.dart';
import 'package:borsa_fiyat/altin_Api.dart';
import 'ana_sayfa.dart';
import 'gold_screen.dart';
import 'kur_screen2.dart';

class islemSayfasi extends StatefulWidget {
  @override
  _islemSayfasiState createState() => _islemSayfasiState();
}

class _islemSayfasiState extends State<islemSayfasi> {
  List<AltinFiyati> _altinList = [];
  String? _selectedAltinType;
  double _selectedAltinPrice = 0.0;
  String _result = "";
  bool _isLoading = true;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchGoldPrices();
  }

  Future<void> _fetchGoldPrices() async {
    try {
      _altinList = await AltinApi().getAltinFiyati();
      if (_altinList.isNotEmpty) {
        setState(() {
          _selectedAltinType = _altinList[0].name;
          _selectedAltinPrice = _altinList[0].sell;
        });
      }
    } catch (e) {
      print("Hata oluştu: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _calculatePrice() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      _result = (amount * _selectedAltinPrice).toStringAsFixed(2) + " ₺";
    });
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = Color(0xFF24268D);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HAREM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: themeColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            // Kategori Butonları
            Container(
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(0),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton('Altın', Icons.attach_money, themeColor, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                  }),
                  _buildCategoryButton('Döviz', Icons.currency_exchange, themeColor, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const KurScreen()));
                  }),
                  _buildCategoryButton('İşlem', Icons.swap_horiz, themeColor, () {}),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Miktar ve Altın Türü Seçimi
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Adet/gr giriniz",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        prefixIcon: Icon(Icons.calculate_outlined, color: themeColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 180,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedAltinType,
                        icon: Icon(Icons.arrow_drop_down, color: themeColor),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedAltinType = newValue;
                            _selectedAltinPrice = _altinList.firstWhere((altin) => altin.name == newValue).sell;
                          });
                        },
                        items: _altinList.map<DropdownMenuItem<String>>((AltinFiyati altin) {
                          return DropdownMenuItem<String>(
                            value: altin.name,
                            child: Text(altin.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Hesapla Butonu
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _calculatePrice,
                  icon: Icon(Icons.swap_horiz, color: Colors.white),
                  label: Text(
                    "HESAPLA",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Sonuç Alanı
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextField(
                readOnly: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: themeColor),
                decoration: InputDecoration(
                  labelText: _result.isNotEmpty ? _result : "₺",
                  labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ),
          ],
        ),
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