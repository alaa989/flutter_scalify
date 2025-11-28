// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scalify Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          background: const Color(0xFFF1F5F9),
          surface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      builder: (context, child) {
        return ResponsiveProvider(
          child: child ?? const SizedBox(),
        );
      },
      home: const ScalifyExampleHome(),
    );
  }
}

class ScalifyExampleHome extends StatelessWidget {
  const ScalifyExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
 
    return LayoutBuilder(
      builder: (context, constraints) {
     
        if (constraints.maxWidth < 250) {
          return Scaffold(
            backgroundColor: const Color(0xFFF1F5F9),
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 250,
                height: constraints.maxHeight,
                child: _buildMainContent(context),
              ),
            ),
          );
        }

       
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          body: _buildMainContent(context),
        );
      },
    );
  }

 
  Widget _buildMainContent(BuildContext context) {
    return AppWidthLimiter(
      maxWidth: 1800,
      child: CustomScrollView(
        slivers: [
         
          SliverAppBar(
            expandedHeight: 180.h,
            pinned: true,
            backgroundColor: const Color(0xFF6366F1),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: CircleAvatar(
                        radius: 80.r,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: [24, 0, 24, 24].p,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: [12, 6].p,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: 8.br,
                            ),
                            child: Text(
                              'V 1.0.0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.fz,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          12.sbh,
                          Text(
                            'Scalify Dashboard',
                            style: TextStyle(
                              fontSize: 28.fz,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

         
          SliverToBoxAdapter(
            child: Padding(
              padding: [16, 24].p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Overview", Icons.dashboard_outlined),
                  16.sbh,

               
                  _buildStatsGrid(context),

                  32.sbh,

                  _buildSectionHeader(
                      "Featured Products", Icons.shopping_bag_outlined),
                  8.sbh,
                  Text(
                    "Resize window to test custom logic (<400, <600, <800, <1100)",
                    style: TextStyle(fontSize: 14.fz, color: Colors.grey[600]),
                  ),
                  16.sbh,

                 
                  _buildProductsGrid(context),

                  40.sbh,
                
                  _buildDeveloperInfo(context),
                  40.sbh,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.iz, color: const Color(0xFF6366F1)),
        12.sbw,
        Text(
          title,
          style: TextStyle(
            fontSize: 22.fz,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }


  Widget _buildStatsGrid(BuildContext context) {
   
    double rawWidth = MediaQuery.of(context).size.width;
    double screenWidth = rawWidth < 200 ? 200 : rawWidth;

  
    int crossAxisCount = screenWidth < 600 ? 2 : 4;

  
    double childAspectRatio = screenWidth < 600 ? 1.5 : 1.2;
    if (screenWidth < 400) {
      childAspectRatio = 1.3;
    }

  
    return Center(
      child: Container(
      
        constraints: BoxConstraints(
            maxWidth: screenWidth > 1200 ? 1200 : double.infinity),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16.s,
          mainAxisSpacing: 16.s,
          childAspectRatio: childAspectRatio,
          children: [
            _buildStatCard('Users', '245K', Icons.people_outline, Colors.blue),
            _buildStatCard(
                'Revenue', '\$45K', Icons.attach_money, Colors.green),
            _buildStatCard(
                'Orders', '1.2K', Icons.shopping_cart_outlined, Colors.orange),
            _buildStatCard('Growth', '+24%', Icons.trending_up, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: 16.br,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: 16.p,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: 8.p,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: 10.br,
                    ),
                    child: Icon(icon, color: color, size: 22.iz),
                  ),
                  8.sbw,
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 14.fz,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

             
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 26.fz,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildProductsGrid(BuildContext context) {
    double rawWidth = MediaQuery.of(context).size.width;
    double screenWidth = rawWidth < 200 ? 200 : rawWidth;

    int crossAxisCount;

    if (screenWidth < 400) {
      crossAxisCount = 1;
    } else if (screenWidth >= 400 && screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth >= 600 && screenWidth < 800) {
      crossAxisCount = 3;
    } else if (screenWidth >= 800 && screenWidth < 1100) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 5;
    }

    double aspectRatio;
    if (crossAxisCount == 1) {
      aspectRatio = 1.2;
    } else if (crossAxisCount == 2) {
      aspectRatio = 0.65;
    } else if (crossAxisCount == 3) {
      aspectRatio = 0.6;
    } else {
      aspectRatio = 0.55;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20.s,
        mainAxisSpacing: 20.s,
        childAspectRatio: aspectRatio,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildProductCard(index);
      },
    );
  }

  Widget _buildProductCard(int index) {
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B)
    ];
    final color = colors[index % colors.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 20.br,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.devices_other,
                      size: 50.iz,
                      color: color,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: [8, 4].p,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: 12.br,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 14.iz, color: Colors.amber),
                          4.sbw,
                          Text("4.8",
                              style: TextStyle(
                                  fontSize: 12.fz,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

        
          Expanded(
            flex: 4,
            child: Padding(
              padding: 12.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Smart Pro ${index + 1}",
                          style: TextStyle(
                            fontSize: 16.fz,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.sbh,
                        Text(
                          "High performance",
                          style: TextStyle(fontSize: 12.fz, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "\$${(index + 1) * 120}",
                            style: TextStyle(
                              fontSize: 18.fz,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 32.ui,
                        height: 32.ui,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: 8.br,
                        ),
                        child:
                            Icon(Icons.add, color: Colors.white, size: 18.iz),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDeveloperInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: [24, 32].p,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
        borderRadius: 24.br,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.code, color: Colors.white, size: 32.iz),
          16.sbh,
          Text(
            "Flutter Scalify Package",
            style: TextStyle(
              fontSize: 20.fz,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          8.sbh,
          Text(
            "Designed & Developed with ❤️ by",
            style: TextStyle(fontSize: 14.fz, color: Colors.white60),
          ),
          24.sbh,
          Container(
            padding: [16, 12].p,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: 50.br,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: const Color(0xFF6366F1),
                  child: Text(
                    "AH",
                    style: TextStyle(
                      fontSize: 12.fz,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                12.sbw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Alaa Hassan Damad",
                        style: TextStyle(
                          fontSize: 14.fz,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Iraq • +9647814054295",
                        style: TextStyle(
                          fontSize: 11.fz,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "alaahassanak772@gmail.com",
                        style: TextStyle(
                          fontSize: 11.fz,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}