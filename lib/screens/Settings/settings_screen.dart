
import 'package:dairyapp/CustomWidets/custom_text_field.dart';
import 'package:dairyapp/CustomWidets/custom_toast.dart';
import 'package:dairyapp/Firebase/firebase_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../Provider/provider_userdata.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController farmNameController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController   milkPriceController=TextEditingController();
  bool _isLoading=false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<FarmProvider>(context, listen: false);
      provider.loadFarmData().then((_) {
        farmNameController.text = provider.farmName;
        ownerNameController.text = provider.ownerName;
        phoneNumberController.text = provider.ownerNumber;
        milkPriceController.text = provider.pricePerLiter == 0.0 ? '' : provider.pricePerLiter.toString();
        setState(() {});
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FarmProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor:Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Font1'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                          color:  const Color(0xFF7CB342),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 40,
                        color:   Color(0xFF7CB342),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: ownerNameController,
                      builder: (context, value, _) {
                        // Use text field value if not empty, otherwise fallback to provider value
                        String displayName = value.text.isNotEmpty
                            ? value.text
                            : provider.ownerName.isNotEmpty
                            ? provider.ownerName
                            : 'Owner Name';
                        return Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Font',
                            color: Colors.black87,
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: farmNameController,
                      builder: (context, value, _) {
                        String displayFarm = value.text.isNotEmpty
                            ? value.text
                            : provider.farmName.isNotEmpty
                            ? provider.farmName
                            : 'Farm Name';
                        return Text(
                          displayFarm,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Font',
                            color: Colors.black87,
                          ),
                        );
                      },
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
                      Text(
                        "Milk Price per Liter",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Font',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomTextField(
                        icon: Icons.money_off,

                        controller: milkPriceController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:_isLoading?null: () async {
                            String farmName = farmNameController.text.trim();
                            String ownerName = ownerNameController.text.trim();
                            String phoneNumber = phoneNumberController.text.trim();
                            String priceText = milkPriceController.text.trim();


                            if (farmName.isEmpty ||
                                ownerName.isEmpty ||
                                phoneNumber.isEmpty ||
                                priceText.isEmpty) {
                            showCustomToast(context, "Please Enter the Required Information");
                              return;
                            }


                            if (phoneNumber.length != 11 || int.tryParse(phoneNumber) == null) {
                              showCustomToast(context, "Phone Number Must be 11 digits");
                              return;
                            }


                            double? price = double.tryParse(priceText);
                            if (price == null || price <= 0) {
                              showCustomToast(context, "Enter a Valid Milk Price");
                              return;
                            }

                            setState(() {
                              _isLoading = false; // Stop loading
                            });
                            try {
                              await FirebaseService().addUserData(
                                farmName: farmName,
                                ownerName: ownerName,
                                ownerNumber: phoneNumber,
                                pricePerLiter: price,
                              );
                              await Provider.of<FarmProvider>(context, listen: false).loadFarmData();

                              showCustomToast(context, "Form Data Saved Successfully");



                            } catch (e) {
                             print(e.toString());
                             showCustomToast(context, "Error");
                            }finally {
                              setState(() {
                                _isLoading = false; // Stop loading
                              });
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor:  const Color(0xFF7CB342),
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

}
