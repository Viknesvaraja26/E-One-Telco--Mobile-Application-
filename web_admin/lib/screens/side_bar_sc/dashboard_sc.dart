import 'package:flutter/material.dart';
import 'package:web_admin/widgets/orders_list.dart';

class DashboardSc extends StatelessWidget {
  static const String routeName = '\DashboardSc';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 500),
                        OrdersList(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
