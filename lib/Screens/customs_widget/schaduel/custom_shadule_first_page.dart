import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/custom_schadule_second_page.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/schaduel/model_schaduale.dart';
import 'package:flutter/material.dart';

class CustomShaduleFirstPage extends StatelessWidget {
  final ModelSchedule modelSchaduale;

  const CustomShaduleFirstPage({
    super.key,
    required this.modelSchaduale,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CustomSchaduleSecondPage(
                modelSchedule: modelSchaduale,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            title: Text(
              modelSchaduale.level,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                modelSchaduale.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ),
      ),
    );
  }
}