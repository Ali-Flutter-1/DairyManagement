
import 'package:dairyapp/Model/milk_model.dart';
import 'package:dairyapp/Provider/milk_provider.dart';
import 'package:dairyapp/screens/Milk/milk_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Firebase/milk_service.dart';

class MilkScreen extends StatefulWidget {
  const MilkScreen({super.key});

  @override
  State<MilkScreen> createState() => _MilkScreenState();
}

class _MilkScreenState extends State<MilkScreen> {
  String selectedPeriod = "Week";

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<MilkProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Milk",
          style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Font1'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 24),
              child: Container(

                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.shade200
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Total Sales
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Row(
                            children: [
                              CircleAvatar(
        
                                child: Icon(Icons.attach_money,   color:  const Color(0xFF7CB342),),
                              ),
        
                              SizedBox(width: 10),
        
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Text(
                                    'Total Sales',
                                    style: TextStyle(color: Colors.grey,fontFamily: 'Font1',fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(provider.totalRevenue.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
        
                            ],
                          ),
        
        
        
                        ],
                      ),
                    ),
        
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
        
                    // Milk Sold
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Row(
                            children: [
                              CircleAvatar(
        
                                child: Icon(Icons.trending_up,   color:  const Color(0xFF7CB342),),
                              ),
                              SizedBox(width: 10),
        
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Text(
                                    'Milk Sold',
                                    style: TextStyle(color: Colors.grey,fontFamily: 'Font1',fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                   provider.totalLitres.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
        
        
                            ],
                          ),
        
        
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            const SizedBox(height: 20),
        
            // --- Time Period Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Time Period:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,fontFamily: 'Font',fontSize: 18
                  ),
                ),
                const SizedBox(width: 10),
                _buildPeriodButton("Week"),
                const SizedBox(width: 8),
                _buildPeriodButton("Month"),
                const SizedBox(width: 8),
                _buildPeriodButton("All"),
              ],
            ),
        
            const SizedBox(height: 5),


            Expanded(
              child: StreamBuilder<List<MilkSale>>(
                stream: MilkService().getAllMilkSales(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.attach_money, color: Color(0xFF7CB342), size: 60),
                          SizedBox(height: 16),
                          Text(
                            "No Sales Recorded",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Font2',
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Start by adding your first sale",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }

                  final sales = snapshot.data!;
                  sales.sort((a, b) => b.date.compareTo(a.date));
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sales.length,
                    itemBuilder: (context, index) {
                      final sale = sales[index];

                      final totalLiters = (sale.morningQuantity) + (sale.eveningQuantity);
                      final totalPrice = totalLiters * sale.pricePerLitre;
                      final formattedDate = DateFormat('dd MMM yyyy').format(sale.date);


                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),

                          color:  Colors.white,






                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Colors.white70,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.local_drink, color: Color(0xFF7CB342)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        sale.customer,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Rs ${totalPrice.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.wb_sunny,
                                        color: Colors.yellow,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${sale.morningQuantity} L",
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(
                                        Icons.nightlight_round,
                                        color: Colors.blueAccent,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${sale.eveningQuantity} L",
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Date: $formattedDate",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Price/Litre: Rs ${sale.pricePerLitre}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                },
              ),
            ),

          ],
        ),
      ),

      // --- Floating Action Button ---
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_milk',  // Unique tag to avoid conflicts
        backgroundColor:
        const Color(0xFF7CB342),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkDescriptionScreen()));

        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPeriodButton(String label) {
    final isSelected = selectedPeriod == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7CB342) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
