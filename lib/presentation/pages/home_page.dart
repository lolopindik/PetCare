import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pet_care/logic/theme/theme_constants.dart';

class HomePage {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 800
          ),
          child: Column(
            children: <Widget>[
              const Gap(20),
              _textTitle(context, 'Recommended food for your pet'),
              Expanded(
                flex: 1,
                child: PageView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: (index % 2 == 0) ? Colors.amber : Colors.green,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    );
                  },
                ),
              ),
              _textTitle(context, 'Possible medications and vitamins'),
              Expanded(
                flex: 1,
                child: PageView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: (index % 2 == 0) ? Colors.amber : Colors.green,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    );
                  },
                )
              ),
              Expanded(
                flex: 1,
                child: PageView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: (index % 2 == 0) ? Colors.amber : Colors.green,
                        borderRadius: BorderRadius.circular(16)
                      ),
                    );
                  },
                ),
              ),
              const Gap(120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: LightModeColors.primaryColor,
              ),
        ),
      ),
    );
  }
}
