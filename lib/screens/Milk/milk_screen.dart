import 'package:flutter/material.dart';

class MilkScreen extends StatefulWidget {
  const MilkScreen({super.key});

  @override
  State<MilkScreen> createState() => _MilkScreenState();
}

class _MilkScreenState extends State<MilkScreen> {
  String selectedPeriod = "Week";

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 24),
              child: Container(
                // padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 24),
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
                      color: Colors.grey.withOpacity(0.15),
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
                        children: const [
                          Row(
                            children: [
                              CircleAvatar(

                                child: Icon(Icons.attach_money, color: Colors.green),
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
                                  Text(
                                    'Rs 0.00',
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
                        children: const [
                          Row(
                            children: [
                              CircleAvatar(

                                child: Icon(Icons.trending_up, color: Colors.green),
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
                                    '0 L',
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

            const SizedBox(height: 40),


            Container(
              width: double.infinity,
                         height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.attach_money,
                    color: Colors.green,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Sales Recorded",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Font2',
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Start by adding your first sale",
                    style: TextStyle(color: Colors.grey,fontSize: 18),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7CB342),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Add Sale",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- Floating Action Button ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF7CB342),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
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
