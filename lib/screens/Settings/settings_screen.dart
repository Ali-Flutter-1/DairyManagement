
import 'package:dairyapp/Auth/login/login_screen.dart';
import 'package:dairyapp/CustomWidets/custom_text_field.dart';
import 'package:dairyapp/CustomWidets/custom_toast.dart';
import 'package:dairyapp/Firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  bool _isSaving = false; // for Save Settings
  bool _isLoggingOut = false; // for Logout button (optional if you want loader outside dialog)


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
      backgroundColor:Colors.white,
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
                          onPressed: _isSaving
                              ? null
                              : () async {
                            setState(() {
                              _isSaving = true;
                            });

                            String farmName = farmNameController.text.trim();
                            String ownerName = ownerNameController.text.trim();
                            String phoneNumber = phoneNumberController.text.trim();
                            String priceText = milkPriceController.text.trim();

                            if (farmName.isEmpty ||
                                ownerName.isEmpty ||
                                phoneNumber.isEmpty ||
                                priceText.isEmpty) {
                              showCustomToast(context, "Please enter all required information",isError: true);
                              setState(() => _isSaving = false);
                              return;
                            }

                            if (phoneNumber.length != 11 || int.tryParse(phoneNumber) == null) {
                              showCustomToast(context, "Phone number must be 11 digits",isError: true);
                              setState(() => _isSaving = false);
                              return;
                            }

                            double? price = double.tryParse(priceText);
                            if (price == null || price <= 0) {
                              showCustomToast(context, "Enter a valid milk price",isError: true);
                              setState(() => _isSaving = false);
                              return;
                            }

                            try {
                              await FirebaseService().addUserData(
                                farmName: farmName,
                                ownerName: ownerName,
                                ownerNumber: phoneNumber,
                                pricePerLiter: price,
                              );
                              await Provider.of<FarmProvider>(context, listen: false)
                                  .loadFarmData();

                              showCustomToast(context, "Form data saved successfully");
                            } catch (e) {
                              showCustomToast(context, "Error saving data",isError: true);
                            } finally {
                              setState(() {
                                _isSaving = false;
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
                          child: _isSaving
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'Save Settings',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      SizedBox(height: 16,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoggingOut ? null : () => _showLogoutDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Logout',
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
  void _showLogoutDialog(BuildContext context) {
    bool _isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // prevent accidental close
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, color: Color(0xFF7CB342), size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Font1',
                        color: Color(0xFF33691E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Are you sure you want to logout?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white24,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                            setStateDialog(() {
                              _isLoading = true;
                            });

                            try {
                              // 🔥 Sign out from Firebase
                              await FirebaseAuth.instance.signOut();

                              // ✅ Optional: also sign out from Google
                              await GoogleSignIn().signOut();

                              // Show confirmation toast
                              showCustomToast(context, "Logged out successfully");


                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    (route) => false,
                              );
                            } catch (e) {
                              showCustomToast(context, "Error: ${e.toString()}",isError: true);
                            } finally {
                              setStateDialog(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7CB342),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                            "Logout",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Font1',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}
