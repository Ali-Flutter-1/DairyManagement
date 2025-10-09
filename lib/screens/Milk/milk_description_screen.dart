
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
                    backgroundColor:  const Color(0xFF7CB342),
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
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 16,
                  ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: 'Date',
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                      icon: Icons.calendar_today,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Morning Quantity (L)',
                      controller: _morningController,

                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Evening Quantity (L)',
                      controller: _eveningController,

                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                    _buildInputField(
                      label: 'Price Per Litre',
                      controller: _priceController,

                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      label: 'Notes (Optional)',
                      controller: _notesController,

                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  const Color(0xFF7CB342),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
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
                          // print("Firebase initialized: ${Firebase.apps.length}");

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

  Widget _buildInputField({
    required String label,
    TextEditingController? controller,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,

            fontWeight: FontWeight.bold,

          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          validator: (value) {
            if (!readOnly && (value?.isEmpty ?? true)) {
              return 'Please enter $label';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey[400])
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4CAF50)),
            ),
            contentPadding: const EdgeInsets.all(16.0),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}