import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/drinkmenu.dart';
import 'package:read_and_brew/screens/ordernborrow%20screens/client/order/ordersummary.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:read_and_brew/widgets/ordernborrow%20widgets/ordernborrow_drawer.dart';
import 'package:responsive_card/responsive_card.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final List<Map<String, dynamic>> suppliesEquipment = [
    {
      "pk": 1,
      "fields": {
        "name": "Coffee Beans",
        "description": "Freshly roasted coffee beans for the perfect brew.",
        "amount": 50
      }
    },
    {
      "pk": 2,
      "fields": {
        "name": "Espresso Machine",
        "description": "High-quality espresso machine for your coffee needs.",
        "amount": 5
      }
    },
    {
      "pk": 3,
      "fields": {
        "name": "Milk Frother",
        "description":
            "Efficient milk frother to create creamy lattes and cappuccinos.",
        "amount": 10
      }
    },
    {
      "pk": 4,
      "fields": {
        "name": "Coffee Cups",
        "description": "Disposable coffee cups for takeout orders.",
        "amount": 200
      }
    },
    {
      "pk": 5,
      "fields": {
        "name": "Coffee Filters",
        "description": "Coffee filters for your drip coffee maker.",
        "amount": 1000
      }
    },
    {
      "pk": 6,
      "fields": {
        "name": "Tea Bags",
        "description": "Assorted tea bags for a variety of flavors.",
        "amount": 100
      }
    },
    {
      "pk": 7,
      "fields": {
        "name": "Coffee Grinder",
        "description": "Professional coffee grinder for fresh coffee grounds.",
        "amount": 8
      }
    },
    {
      "pk": 8,
      "fields": {
        "name": "Syrup Dispenser",
        "description": "Dispenser for flavored syrups for your beverages.",
        "amount": 15
      }
    },
    {
      "pk": 9,
      "fields": {
        "name": "Coffee Stirrers",
        "description": "Wooden coffee stirrers for stirring hot beverages.",
        "amount": 500
      }
    },
    {
      "pk": 10,
      "fields": {
        "name": "Sugar Packets",
        "description": "Individual sugar packets for sweetening drinks.",
        "amount": 300
      }
    },
    {
      "pk": 11,
      "fields": {
        "name": "Hot Water Kettle",
        "description": "Electric kettle for boiling water quickly.",
        "amount": 6
      }
    },
    {
      "pk": 12,
      "fields": {
        "name": "Espresso Cups",
        "description": "Espresso shot cups for serving espresso shots.",
        "amount": 50
      }
    },
    {
      "pk": 13,
      "fields": {
        "name": "Lids for Cups",
        "description": "Plastic lids for coffee cups to prevent spills.",
        "amount": 400
      }
    },
    {
      "pk": 14,
      "fields": {
        "name": "Napkins",
        "description": "Paper napkins for customers to use.",
        "amount": 1000
      }
    },
    {
      "pk": 15,
      "fields": {
        "name": "Coffee Spoons",
        "description": "Small coffee spoons for stirring hot drinks.",
        "amount": 600
      }
    },
    {
      "pk": 16,
      "fields": {
        "name": "Coffee Creamer",
        "description": "Dairy and non-dairy creamer options for coffee.",
        "amount": 40
      }
    },
    {
      "pk": 17,
      "fields": {
        "name": "Cocoa Powder",
        "description": "High-quality cocoa powder for making hot chocolate.",
        "amount": 20
      }
    },
    {
      "pk": 18,
      "fields": {
        "name": "Disposable Stirrers",
        "description": "Disposable stirrers for hot and cold drinks.",
        "amount": 500
      }
    },
    {
      "pk": 19,
      "fields": {
        "name": "Tea Infusers",
        "description": "Tea infusers for loose leaf tea brewing.",
        "amount": 30
      }
    },
    {
      "pk": 20,
      "fields": {
        "name": "Lemon Slices",
        "description": "Slices of fresh lemon for garnishing drinks.",
        "amount": 100
      }
    },
    {
      "pk": 21,
      "fields": {
        "name": "Honey Packets",
        "description":
            "Individual honey packets for sweetening tea and coffee.",
        "amount": 150
      }
    },
    {
      "pk": 22,
      "fields": {
        "name": "Ice Scoops",
        "description": "Ice scoops for adding ice to cold beverages.",
        "amount": 25
      }
    },
    {
      "pk": 23,
      "fields": {
        "name": "Straws",
        "description": "Plastic straws for cold drinks.",
        "amount": 1000
      }
    },
    {
      "pk": 24,
      "fields": {
        "name": "Whipped Cream Dispenser",
        "description": "Dispenser for whipped cream toppings.",
        "amount": 5
      }
    },
    {
      "pk": 25,
      "fields": {
        "name": "Sugar Cubes",
        "description": "Individual sugar cubes for coffee and tea.",
        "amount": 200
      }
    },
    {
      "pk": 26,
      "fields": {
        "name": "Drink Napkins",
        "description": "Small drink napkins for beverage service.",
        "amount": 800
      }
    },
    {
      "pk": 27,
      "fields": {
        "name": "Reusable Coffee Filters",
        "description":
            "Eco-friendly reusable coffee filters for sustainable brewing.",
        "amount": 30
      }
    },
    {
      "pk": 28,
      "fields": {
        "name": "Matcha Powder",
        "description":
            "High-quality matcha powder for making matcha lattes and other green tea beverages.",
        "amount": 10
      }
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order & Borrow - Inventory'),
        backgroundColor: Color(0xFF377C35),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SizedBox(
        width: 600,
        child: ListView(
          children: List.generate(
            suppliesEquipment.length,
            (index) {
              var suppliesList = suppliesEquipment[index]['fields'];
              return ResponsiveCard(
                elevation: 5,
                titleGap: 20,
                bgColor: Colors.white,
                screenWidth: 600,
                title: Text(
                  suppliesList['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 21),
                ),
                subTitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${suppliesList['description']}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Amount: ${suppliesList['amount']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
