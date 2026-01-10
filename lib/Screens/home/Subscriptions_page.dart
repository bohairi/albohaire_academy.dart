import 'package:buhairi_academy_application/Screens/customs_widget/subscription/subscription_main_page.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isAnnual = true; 
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SubscriptionMainPage(),
        if(isShow) Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Membership", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => setState(() {
            isShow = false;
          })
        ),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Icon(Icons.auto_awesome, size: 80, color: Colors.amber),
              SizedBox(height: 20),
              Text(
                "Join us and become a member",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              Container(
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
              SizedBox(height: 30),

              _buildPlanCard(
                title: isAnnual ? "Yearly Plan" : "Monthly Plan",
                price: isAnnual ? "180 JOD" : "20 JOD",
                subtitle: isAnnual ? "Save three months" : "Renews automatically every month",
                isRecommended: isAnnual,
              ),


              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed:() => setState(() {
            isShow = false;
          }),
                  child: Text("Subscribe now", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    )
      ],
    );
   
  }

  Widget _toggleButton(String title, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildPlanCard({required String title, required String price, required String subtitle, bool isRecommended = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isRecommended 
            ? LinearGradient(colors: [Colors.blueAccent, Colors.blue.shade900])
            : null,
        color: isRecommended ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          if (isRecommended)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
              child: Text("Most common", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          SizedBox(height: 10),
          Text(title, style: TextStyle(color: isRecommended ? Colors.white : Colors.black, fontSize: 18)),
          SizedBox(height: 5),
          Text(price, style: TextStyle(color: isRecommended ? Colors.white : Colors.blueAccent, fontSize: 32, fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(color: isRecommended ? Colors.white70 : Colors.grey)),
        ],
      ),
    );
  }

  
}