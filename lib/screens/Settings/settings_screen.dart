import 'package:dairyapp/CustomWidets/customTextfield.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController farmNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Font1'),
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
              // Profile Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4CAF50),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rana Ahmad Tahir',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Font',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rana Dairy Farm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Font1',
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              // Farm Information Section
              const Text(
                'Farm Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),


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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Farm Name",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Font',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomTextField(
                          icon: Icons.home,

                          controller: farmNameController,
                          keyboardType: TextInputType.name,
                        ),

                        SizedBox(height: 16),
                        Text(
                          "Owner Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Font',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomTextField(
                          icon: Icons.person,

                          controller: ownerNameController,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Contact Number",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Font',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomTextField(
                          icon: Icons.phone,
                          maxLength: 13,
                          prefixText: '+92 3',
                          controller: phoneNumberController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              // Business Settings Section
              const Text(
                'Business Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Font'
                ),
              ),
              const SizedBox(height: 16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        label: 'Milk Rate (per liter)',
                        prefixText: '\$ ',
                        value: '180',
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    IconData? icon,
    String? prefixText,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,

            fontWeight: FontWeight.w600,
            fontFamily: "Font"
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Icon(icon, color: Colors.grey[400])
                  : null,
              prefixText: prefixText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16.0),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
