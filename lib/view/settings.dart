import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:joint_cost/viewmodel/setting_model.dart";

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SettingModel>(
        // Consumerを使用してSettingModelの変更をリッスン
        builder: (context, model, child) => ListView(
          children: [
            AppBar(
              title: const Text("設定"),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            ListTile(
              title: const Text("週の始まり"),
              subtitle: const Text("週の始まる曜日を設定できます"),
              trailing: DropdownButton<String>(
                value: model.startPageA
                    ? "日曜"
                    : "月曜", // Consumerを使用しているため、選択が即時に反映される
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    await model.setStartPageA(newValue == "日曜");
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
    );
  }
}
