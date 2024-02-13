import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:joint_cost/viewmodel/setting_model.dart";

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (_) => SettingModel()..getSetting(),
      child: Scaffold(
        body: Consumer(
          builder: (
            BuildContext context,
            SettingModel model,
            Widget? child,
          ) =>
              ListView(
            children: [
              AppBar(
                title: const Text("設定"),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              ListTile(
                title: const Text("カレンダー始まり"),
                subtitle: const Text("曜日の始まりを設定できます"),
                trailing: DropdownButton<String>(
                  value: model.startPageA ? "日曜" : "月曜",
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      model.setStartPageA(newValue == "日曜");
                      debugPrint(newValue);
                    }
                  },
                  items: <String>["日曜", "月曜"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
