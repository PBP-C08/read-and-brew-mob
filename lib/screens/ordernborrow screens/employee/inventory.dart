import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_and_brew/widgets/left_drawer.dart';
import 'package:responsive_card/responsive_card.dart';
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
        "amount": 50,
        "picture":
            "https://media.istockphoto.com/id/1249763975/photo/fresh-roasted-coffee-beans-with-burlap-sack-on-a-wooden-table.jpg?s=612x612&w=0&k=20&c=BC_P1VR0_IJ9DRkb2dbZ1sKN2U4eZGn73kxdh9uJFD4="
      }
    },
    {
      "pk": 2,
      "fields": {
        "name": "Espresso Machine",
        "description": "High-quality espresso machine for your coffee needs.",
        "amount": 5,
        "picture":
            "https://media.istockphoto.com/id/1298501845/photo/close-up-barista-hand-inserts-the-metal-filter-in-the-coffee-machine-waiting-for-pouring-hot.jpg?s=612x612&w=0&k=20&c=Yey3fVCCAFlXuac9x8J7yh-emzYR0DiGt74wcpNNlyY="
      }
    },
    {
      "pk": 3,
      "fields": {
        "name": "Milk Frother",
        "description":
            "Efficient milk frother to create creamy lattes and cappuccinos.",
        "amount": 10,
        "picture":
            "https://media.istockphoto.com/id/1291792084/photo/mixing-milk-in-glass-by-milk-frother-making-foamy-milk-with-frother-milk-handheld-mixer.jpg?s=612x612&w=0&k=20&c=up0VOGsXGuR3kJ2Pz4s5QbxcdYCNFBt7HgfDjZbHJCA="
      }
    },
    {
      "pk": 4,
      "fields": {
        "name": "Coffee Cups",
        "description": "Disposable coffee cups for takeout orders.",
        "amount": 200,
        "picture":
            "https://media.istockphoto.com/id/472113574/photo/cups-of-coffee.jpg?s=612x612&w=0&k=20&c=J8-_LZt6Nzne6Afg0amnBnBuWG5kyj2Emnd6NY9GsRk="
      }
    },
    {
      "pk": 5,
      "fields": {
        "name": "Coffee Filters",
        "description": "Coffee filters for your drip coffee maker.",
        "amount": 1000,
        "picture":
            "https://images.squarespace-cdn.com/content/v1/5957d4148419c29314283239/1499458134301-XXM4VD3X64OSIKVTXE7P/Kalita.jpg"
      }
    },
    {
      "pk": 6,
      "fields": {
        "name": "Tea Bags",
        "description": "Assorted tea bags for a variety of flavors.",
        "amount": 100,
        "picture":
            "https://media.istockphoto.com/id/499262293/photo/jasmine-green-tea.jpg?s=612x612&w=0&k=20&c=T5PctoAEL1PUrKBRBetmH6lO2ZnkPWqQ_MY591YaYKI="
      }
    },
    {
      "pk": 7,
      "fields": {
        "name": "Coffee Grinder",
        "description": "Professional coffee grinder for fresh coffee grounds.",
        "amount": 8,
        "picture":
            "https://media.istockphoto.com/id/1319489361/photo/close-up-of-portafilter-in-hands-of-barista-into-which-coffee-grinder-pours-ground-coffee.jpg?s=612x612&w=0&k=20&c=ciSyhcW4D8ISsJPv3kvftLloiqByCzeZ2MijBHRZ_cI="
      }
    },
    {
      "pk": 8,
      "fields": {
        "name": "Syrup Dispenser",
        "description": "Dispenser for flavored syrups for your beverages.",
        "amount": 15,
        "picture":
            "https://media.istockphoto.com/id/1134667542/photo/row-of-pump-head-bottle-of-beverage-or-syrup-in-cafe.jpg?s=612x612&w=0&k=20&c=kG77BMY9mN5rDe_1xRnq96exsSl3wmz9OCJrRumMAVs="
      }
    },
    {
      "pk": 9,
      "fields": {
        "name": "Coffee Stirrers",
        "description": "Wooden coffee stirrers for stirring hot beverages.",
        "amount": 500,
        "picture":
            "https://media.istockphoto.com/id/1128129200/photo/stir-sticks-and-coffee-beans.jpg?s=612x612&w=0&k=20&c=W5WmbpUgGYoLTqm2bubezDYCg5V-eoDHrZwkJ6-tw70="
      }
    },
    {
      "pk": 10,
      "fields": {
        "name": "Sugar Packets",
        "description": "Individual sugar packets for sweetening drinks.",
        "amount": 300,
        "picture":
            "https://media.istockphoto.com/id/1125582977/photo/pouring-sugar-from-packet-into-coffee-cup.jpg?s=612x612&w=0&k=20&c=gCBCLR2LwX-XWjkpFHPoYrxsd8vsWwh6C868xtXDLAg="
      }
    },
    {
      "pk": 11,
      "fields": {
        "name": "Hot Water Kettle",
        "description": "Electric kettle for boiling water quickly.",
        "amount": 6,
        "picture":
            "https://www.shutterstock.com/image-photo/transparent-electric-kettle-boiling-water-600nw-1556484236.jpg"
      }
    },
    {
      "pk": 12,
      "fields": {
        "name": "Espresso Cups",
        "description": "Espresso shot cups for serving espresso shots.",
        "amount": 50,
        "picture":
            "https://i2.wp.com/blog.lacolombe.com/wp-content/uploads/2015/10/espresso-copy.jpg"
      }
    },
    {
      "pk": 13,
      "fields": {
        "name": "Lids for Cups",
        "description": "Plastic lids for coffee cups to prevent spills.",
        "amount": 400,
        "picture":
            "https://st2.depositphotos.com/25706078/46416/i/450/depositphotos_464163824-stock-photo-two-paper-cups-lid-park.jpg"
      }
    },
    {
      "pk": 14,
      "fields": {
        "name": "Napkins",
        "description": "Paper napkins for customers to use.",
        "amount": 1000,
        "picture":
            "https://media.istockphoto.com/id/186843509/photo/cocktail-napkin-on-wood.jpg?s=612x612&w=0&k=20&c=tNiBOIaqG8Oz5yJbamnMjHEATysE_BSuccJAcB3mrHs="
      }
    },
    {
      "pk": 15,
      "fields": {
        "name": "Coffee Spoons",
        "description": "Small coffee spoons for stirring hot drinks.",
        "amount": 600,
        "picture":
            "https://media.istockphoto.com/id/618972606/photo/coffee-beans-roasted-instant-and-grinded-coffee.jpg?s=612x612&w=0&k=20&c=yUMNjrUfTngv5sLhuT3O8-VEpnBgZm7UPzJJinXZsAg="
      }
    },
    {
      "pk": 16,
      "fields": {
        "name": "Coffee Creamer",
        "description": "Dairy and non-dairy creamer options for coffee.",
        "amount": 40,
        "picture":
            "https://media.istockphoto.com/id/1216174435/photo/barista-hand-making-cappuccino-coffee-with-espresso-machine-in-cafe.jpg?s=612x612&w=0&k=20&c=LZtSttGjwkvrQCl-YpCt_7CUx4Z03KBMTj16jvo1sKM="
      }
    },
    {
      "pk": 17,
      "fields": {
        "name": "Cocoa Powder",
        "description": "High-quality cocoa powder for making hot chocolate.",
        "amount": 20,
        "picture":
            "https://media.istockphoto.com/id/1296362170/photo/detail-of-cocoa-fruit-with-pieces-of-chocolate-and-cocoa-powder-on-raw-cocoa-beans.jpg?s=612x612&w=0&k=20&c=_t5-x-t-hHJiBZTXcM9Nb_CjUF7wAFVLX0MXDVrsDaA="
      }
    },
    {
      "pk": 18,
      "fields": {
        "name": "Disposable Stirrers",
        "description": "Disposable stirrers for hot and cold drinks.",
        "amount": 500,
        "picture":
            "https://media.istockphoto.com/id/897221182/photo/brown-plastic-stir-sticks.jpg?s=612x612&w=0&k=20&c=UYIM9v4dkOAzS3RYWTSo1xU-qtTAESb9mu15ZqFgUEM="
      }
    },
    {
      "pk": 19,
      "fields": {
        "name": "Tea Infusers",
        "description": "Tea infusers for loose leaf tea brewing.",
        "amount": 30,
        "picture":
            "https://media.istockphoto.com/id/467293044/photo/tea-ball-with-black-tea-and-red-fruit.jpg?s=612x612&w=0&k=20&c=72Gp_cXzOew7mhyFOliDTHH2abwLlM1rUQg5ZwouBXE="
      }
    },
    {
      "pk": 20,
      "fields": {
        "name": "Lemon Slices",
        "description": "Slices of fresh lemon for garnishing drinks.",
        "amount": 100,
        "picture":
            "https://media.istockphoto.com/id/175592069/photo/lemon-background.jpg?s=170667a&w=0&k=20&c=GAnJNzIsinuV92_lXqwNVpqVYZFg24Tzzxz36A6fuaE="
      }
    },
    {
      "pk": 21,
      "fields": {
        "name": "Honey Pots",
        "description": "Honey pots for sweetening tea and coffee.",
        "amount": 150,
        "picture":
            "https://media.istockphoto.com/id/598241944/photo/honey-in-jar-and-bunch-of-dry-lavender.jpg?s=612x612&w=0&k=20&c=gVg1BaJ78uniQbpfdFiYvMzim98gREdx-5c4ENBp2tE="
      }
    },
    {
      "pk": 22,
      "fields": {
        "name": "Ice Scoops",
        "description": "Ice scoops for adding ice to cold beverages.",
        "amount": 25,
        "picture":
            "https://media.istockphoto.com/id/138143844/photo/a-photograph-of-a-bucket-of-ice-with-a-trowel.jpg?s=612x612&w=0&k=20&c=qoKM-hHihgSsglkGq2uo5SyjiZy4Ygzq59kFZpkaP-E="
      }
    },
    {
      "pk": 23,
      "fields": {
        "name": "Straws",
        "description": "Plastic straws for cold drinks.",
        "amount": 1000,
        "picture":
            "https://media.istockphoto.com/id/1175305045/video/hand-stirring-tasty-ice-coffee.jpg?s=640x640&k=20&c=H2EQmBt6TNCkqY8nJQ_4HWYeiaRa0b_UE3a_sSG-epU="
      }
    },
    {
      "pk": 24,
      "fields": {
        "name": "Whipped Cream Dispenser",
        "description": "Dispenser for whipped cream toppings.",
        "amount": 5,
        "picture":
            "https://media.istockphoto.com/id/933035364/photo/ice-cream-machine.jpg?s=612x612&w=0&k=20&c=v22SYCiQNCeLT9lqF1ZPhQXDyp0ffPoSGRsoYPnLwj8="
      }
    },
    {
      "pk": 25,
      "fields": {
        "name": "Sugar Cubes",
        "description": "Individual sugar cubes for coffee and tea.",
        "amount": 200,
        "picture":
            "https://media.istockphoto.com/id/1144176000/photo/sugar-sand-and-sugar-cubes-poured-from-a-wooden-spoon.jpg?s=612x612&w=0&k=20&c=Cf7zubWcfiJfM6r4biomdgioHn6OFdbQgHjzHqU6Q1M="
      }
    },
    {
      "pk": 26,
      "fields": {
        "name": "Drink Napkins",
        "description": "Small drink napkins for beverage service.",
        "amount": 800,
        "picture":
            "https://media.istockphoto.com/id/814918828/photo/white-paper-napkin-on-table.jpg?s=612x612&w=0&k=20&c=LbLYFKeuazAI6OLg41z1_mvybf47gpSF1YklQ1CTB6A="
      }
    },
    {
      "pk": 27,
      "fields": {
        "name": "Reusable Coffee Filters",
        "description":
            "Eco-friendly reusable coffee filters for sustainable brewing.",
        "amount": 30,
        "picture":
            "https://media.istockphoto.com/id/1135173539/photo/reusable-metal-mesh-coffee-filter-for-drip-coffee-maker-permanent-basket-coffee-filter-on.jpg?s=612x612&w=0&k=20&c=dMdSbmdznVtalWGN4XfcbHp3E4QN7qGVNQSyGPM4zlE="
      }
    },
    {
      "pk": 28,
      "fields": {
        "name": "Matcha Powder",
        "description":
            "High-quality matcha powder for making matcha lattes and other green tea beverages.",
        "amount": 10,
        "picture":
            "https://media.istockphoto.com/id/865227762/photo/matcha-green-tea.jpg?s=612x612&w=0&k=20&c=AmdEj8LixXw_lPZu2xqn0BrtYhVZkczAckfk2HvDN5s="
      }
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: const Color(0xFF377C35),
        backgroundColor: Colors.white,
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
                action: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        suppliesList['picture'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
