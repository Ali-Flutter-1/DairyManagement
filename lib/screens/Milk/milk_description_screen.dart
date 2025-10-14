
import 'package:dairyapp/CustomWidets/custom_inner_text_field.dart';
import 'package:dairyapp/Provider/milk_provider.dart';
import 'package:dairyapp/Provider/provider_userdata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../CustomWidets/custom_toast.dart';
import '../../Model/milk_model.dart';

class MilkDescriptionScreen extends StatefulWidget {
  const MilkDescriptionScreen({super.key});

  @override
  State<MilkDescriptionScreen> createState() => _MilkDescriptionScreenState();
}

class _MilkDescriptionScreenState extends State<MilkDescriptionScreen> {



  final _morningController = TextEditingController();
  final _eveningController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String selectedSession = 'Morning'; // Add this variable
  final _quantityController = TextEditingController(); // Add this controller


  bool _isLoading=false;

  String selectedThing= "Other";

  @override
  void dispose() {
    _morningController.dispose();
    _eveningController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    final priceProvider = Provider.of<FarmProvider>(context, listen: false);
    _priceController.text = priceProvider.pricePerLiter.toString();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(onTap: (){
          Navigator.pop(context);
        },
            child: Icon(Icons.arrow_back_outlined,     color:  const Color(0xFF7CB342),)),
        title:  Text(
          "New Milk Entry",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Font1',       color:  const Color(0xFF7CB342),),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor:   Color(0xFF7CB342),
                    child: Icon(
                      Icons.opacity,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'New Milk Entry',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Record milk production and sale',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1), // soft grey shadow
                        blurRadius: 8, // how soft the shadow looks
                        spreadRadius: 2, // how far it spreads
                        offset: const Offset(0, 3), // slightly below the container
                      ),
                    ],
                  ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 16,
                  ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInnerInputField(
                      label: 'Date',
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      icon: Icons.calendar_today,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    // Morning Quantity Dropdown
                    const Text(
                      'Select Session',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSession,
                          items: ['Morning', 'Evening']
                              .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSession = value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    CustomInnerInputField(
                      label: 'Quantity (L)',
                      hintText: "Enter Milk Liter's",
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Customer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        _buildTabButton("My Home"),
                        const SizedBox(width: 10),
                        _buildTabButton("Doodhi"),

                        const SizedBox(width: 8),
                        _buildTabButton("Other"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomInnerInputField(
                      label: 'Price Per Litre',
                      controller: _priceController,

                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomInnerInputField(
                      label: 'Notes (Optional)',
                      controller: _notesController,

                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child:
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null // Disable button while loading
                            : () async {
                          final quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;
                          final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
                          final notes = _notesController.text.trim();

                          if (quantity <= 0) {
                            showCustomToast(context, "Please enter a valid milk quantity",isError: true);
                            return;
                          }

                          final sale = MilkSale(
                            morningQuantity: selectedSession == 'Morning' ? quantity : 0.0,
                            eveningQuantity: selectedSession == 'Evening' ? quantity : 0.0,
                            pricePerLitre: price,
                            notes: notes,
                            customer: selectedThing,
                            date: _selectedDate,
                            createdAt: DateTime.now(),
                          );


                          if (price <= 0) {
                            showCustomToast(context, "Invalid price. Please enter or use default price.",isError: true);
                            return;
                          }




                          setState(() {
                            _isLoading = true; // Start loading
                          });

                          try {
                            await Provider.of<MilkProvider>(context, listen: false).addMilkSale(sale);
                            showCustomToast(context, "Milk Entry saved successfully");

                            _morningController.clear();
                            _eveningController.clear();
                            _priceController.clear();
                            _notesController.clear();
                            Navigator.pop(context);
                          } catch (e) {
                            showCustomToast(context, "Error :$e",isError: true);
                          } finally {
                            setState(() {
                              _isLoading = false; // Stop loading
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7CB342),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Save Entry',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                      Navigator.pop(context);

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Colors.white,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Color(0xFF7CB342)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              ) ],
          ),
        ),
      ),
    );
  }



  Widget _buildTabButton(String label) {
    final isSelected = selectedThing == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedThing = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
            color: isSelected ?    Color(0xFF7CB342) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isSelected?    Color(0xFF7CB342):Colors.grey.shade200,
                width: 2
            )
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