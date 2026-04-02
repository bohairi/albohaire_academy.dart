import 'package:buhairi_academy_application/Screens/customs_widget/subscription/subscription_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isAnnual = true;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        bool isSubscribed = false;
        String subscriptionType = "";

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          isSubscribed = data["isSubscribed"] ?? false;
          subscriptionType = data["subscriptionType"] ?? "";
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "Membership",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SubscriptionMainPage(
                              isAnnual: isAnnual,
                            ),
                          ),
                        );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, size: 80, color: Colors.amber),
                  const SizedBox(height: 20),
                  Text(
                    isSubscribed
                        ? "You already have an active membership"
                        : "Join us and become a member",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  if (isSubscribed)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.verified, color: Colors.green, size: 35),
                          const SizedBox(height: 8),
                          const Text(
                            "Membership Active",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (subscriptionType.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              "Current Plan: $subscriptionType",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),

                  Opacity(
                    opacity: isSubscribed ? 0.5 : 1,
                    child: IgnorePointer(
                      ignoring: isSubscribed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isAnnual = false),
                                child: _toggleButton("Monthly", !isAnnual),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => isAnnual = true),
                                child: _toggleButton("Yearly", isAnnual),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Opacity(
                    opacity: isSubscribed ? 0.6 : 1,
                    child: _buildPlanCard(
                      title: isAnnual ? "Yearly Plan" : "Monthly Plan",
                      price: isAnnual ? "180 JOD" : "20 JOD",
                      subtitle: isAnnual
                          ? "Save three months"
                          : "Renews automatically every month",
                      isRecommended: isAnnual,
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSubscribed ? Colors.grey : Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (isSubscribed) {
                          showMessage("You are already subscribed");
                          return;
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SubscriptionMainPage(
                              isAnnual: isAnnual,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        isSubscribed ? "Already subscribed" : "Subscribe now",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _toggleButton(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.blueAccent : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String subtitle,
    bool isRecommended = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isRecommended
            ? LinearGradient(colors: [Colors.blueAccent, Colors.blue.shade900])
            : null,
        color: isRecommended ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Most common",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: isRecommended ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            price,
            style: TextStyle(
              color: isRecommended ? Colors.white : Colors.blueAccent,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: isRecommended ? Colors.white70 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}