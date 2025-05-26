import 'package:farm_expense_mangement_app/screens/feed/feedpage.dart';
import 'package:farm_expense_mangement_app/screens/home/animallist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'milkavgpage.dart';
import '../transaction/transactionpage.dart';
import 'localisations_en.dart';
import 'localisations_hindi.dart';
import 'localisations_punjabi.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  final Color myColor = const Color(0xFF39445A);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(240),
      child: AppBar(
        centerTitle: true,
        flexibleSpace: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
          child: Stack(
            children: [
              Image.asset(
                'asset/bg.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      myColor.withOpacity(0.3),
                      myColor.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                ),
              ),
            ],
          ),
        ),
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(240);
}

class HomePage extends StatefulWidget implements PreferredSizeWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HomePageState extends State<HomePage> {
  late Map<String, String> currentLocalization = {};
  late String languageCode = 'en';

  @override
  void initState() {
    super.initState();
    setState(() {
      currentLocalization = LocalizationEn.translations;
    });
  }

  @override
  Widget build(BuildContext context) {
    languageCode = Provider.of<AppData>(context).persistentVariable;
    print(languageCode);
    if (languageCode == 'en') {
      currentLocalization = LocalizationEn.translations;
    } else if (languageCode == 'hi') {
      currentLocalization = LocalizationHi.translations;
    } else if (languageCode == 'pa') {
      currentLocalization = LocalizationPun.translations;
    }
    Color totalCowsColor = const Color.fromRGBO(224, 191, 184, 1.0); // Green color
    Color milkingCowsColor = const Color.fromRGBO(252, 222, 172, 1.0); // Red color
    Color dryCowsColor = const Color.fromRGBO(88, 148, 120, 1.0); // Blue color
    Color avgMilkPerCowColor = const Color.fromRGBO(202, 217, 173, 1.0); // Yellow color
    return Placeholder(
      strokeWidth: 0,
      color: Colors.white70,
      child: Container(
        height: 600,
        color: Colors.grey[300],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              '𝒹𝒶𝒾𝓇𝓎 𝓈𝒶𝓃𝑔𝓇𝒶𝒽',
              style: TextStyle(
                fontSize: 35, // Adjust the size as needed
                fontWeight: FontWeight.bold,
                color: Colors.black87, // You can choose a color that fits your theme
              ),
            ),
            const SizedBox(height: 16), // Space between the text and the content
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      'cattles',
                      'asset/cat.png',
                      totalCowsColor,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnimalList1()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      'Inventory',
                      'asset/inventory.png',
                      milkingCowsColor,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FeedPage()),
                      ),
                    ),

                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      'transaction',
                      'asset/transact_1.png',
                      dryCowsColor,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransactionPage(showIncome: true,)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildClickableContainer(
                      context,
                      ' Milk Details',
                      'asset/milk.png',
                      avgMilkPerCowColor,
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AvgMilkPage()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildClickableContainer(
      BuildContext context,
      String value,
      String imageUrl,
      Color containerColor,
      Function() onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25, // Keep container size the same
        decoration: BoxDecoration(
          color: const Color.fromRGBO(4, 142, 161, 1.0),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(14, 14, 14, 13),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(32),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      topLeft: Radius.circular(16),
                  ),
                  child: Image.asset(
                    imageUrl,
                    width: MediaQuery.of(context).size.width, // Increased image size
                    height: MediaQuery.of(context).size.height * 0.154, // Increased image size
                    fit: BoxFit.cover, // Ensures the image fits well without overflowing
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  currentLocalization[value] ?? value,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}