import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:tasktune/env/env.dart';

final client = OpenAIClient(apiKey: Env.apiKey);

const metTable = [
  {"activity": "Sleeping", "met": 0.95},
  {"activity": "Meditating", "met": 1.0},
  {"activity": "Watching TV while sitting", "met": 1.3},
  {"activity": "Playing board games", "met": 1.5},
  {"activity": "Watering your lawn", "met": 1.5},
  {"activity": "Playing chess", "met": 1.5},
  {"activity": "Washing dishes", "met": 1.8},
  {"activity": "Ironing", "met": 1.8},
  {"activity": "Doing laundry", "met": 2.0},
  {"activity": "Ice fishing", "met": 2.0},
  {"activity": "Very slow walking", "met": 2.0},
  {"activity": "Nadisodhana yoga", "met": 2.0},
  {"activity": "Stretching", "met": 2.3},
  {"activity": "Dusting", "met": 2.3},
  {"activity": "Grocery shopping", "met": 2.3},
  {"activity": "Hatha yoga", "met": 2.5},
  {"activity": "Carrying out the trash", "met": 2.5},
  {"activity": "Camping", "met": 2.5},
  {"activity": "Standing", "met": 2.5},
  {"activity": "Snow blowing", "met": 2.5},
  {"activity": "Putting away groceries", "met": 2.5},
  {"activity": "Bow hunting", "met": 2.5},
  {"activity": "Watering plants", "met": 2.5},
  {"activity": "Slow pace walking", "met": 2.8},
  {"activity": "Slow dancing", "met": 3.0},
  {"activity": "Walking the dog", "met": 3.0},
  {"activity": "Hammering nails", "met": 3.0},
  {"activity": "Light yard work", "met": 3.0},
  {"activity": "Pilates", "met": 3.0},
  {"activity": "Diving", "met": 3.0},
  {"activity": "Washing windows", "met": 3.2},
  {"activity": "Sweeping", "met": 3.3},
  {"activity": "Walking downhill", "met": 3.3},
  {"activity": "Cooking dinner", "met": 3.3},
  {"activity": "Making your bed", "met": 3.3},
  {"activity": "Vacuuming", "met": 3.3},
  {"activity": "Squat using squat machine", "met": 3.5},
  {"activity": "Fishing", "met": 3.5},
  {"activity": "Mopping", "met": 3.5},
  {"activity": "Moderate speed walking", "met": 3.5},
  {"activity": "Bicycling 5.5 mph", "met": 3.5},
  {"activity": "Cleaning the garage", "met": 3.5},
  {"activity": "Giving the dog a bath", "met": 3.5},
  {"activity": "Using leaf blower", "met": 3.5},
  {"activity": "Walking moderate pace", "met": 3.5},
  {"activity": "Buildling a fence", "met": 3.8},
  {"activity": "Gymnastics", "met": 3.8},
  {"activity": "Raking leaves", "met": 3.8},
  {"activity": "Bowling", "met": 3.8},
  {"activity": "Trimming shrubs and trees", "met": 4.0},
  {"activity": "Paddleboat", "met": 4.0},
  {"activity": "Volleyball", "met": 4.0},
  {"activity": "Curling", "met": 4.0},
  {"activity": "Circuit training", "met": 4.3},
  {"activity": "Brisk speed walking", "met": 4.3},
  {"activity": "Slow pace stair climbing", "met": 4.4},
  {"activity": "Weeding your garden", "met": 4.5},
  {"activity": "Crab fishing", "met": 4.5},
  {"activity": "Chopping wood", "met": 4.5},
  {"activity": "Planting trees", "met": 4.5},
  {"activity": "Removing carpet", "met": 4.5},
  {"activity": "Rowing, stationary", "met": 4.8},
  {"activity": "Tap", "met": 4.8},
  {"activity": "Golf", "met": 4.8},
  {"activity": "Cricket", "met": 4.8},
  {"activity": "Skateboarding", "met": 5.0},
  {"activity": "Cleaning your gutters", "met": 5.0},
  {"activity": "Ballet", "met": 5.0},
  {"activity": "Elliptical trainer", "met": 5.0},
  {"activity": "Unicycling", "met": 5.0},
  {"activity": "Boot camp training", "met": 5.0},
  {"activity": "Low impact aerobics", "met": 5.0},
  {"activity": "Laying sod", "met": 5.0},
  {"activity": "Baseball", "met": 5.0},
  {"activity": "Softball", "met": 5.0},
  {"activity": "Moderate snow shoveling", "met": 5.3},
  {"activity": "Water aerobics", "met": 5.3},
  {"activity": "Ballroom dancing", "met": 5.5},
  {"activity": "Horseback riding", "met": 5.5},
  {"activity": "Step aerobics with 4” step", "met": 5.5},
  {"activity": "Mowing the lawn", "met": 5.5},
  {"activity": "Squats with resistance band", "met": 5.5},
  {"activity": "Marching band", "met": 5.5},
  {"activity": "Swimming laps, moderate", "met": 5.8},
  {"activity": "Moderate rowing", "met": 5.8},
  {"activity": "Dodgeball", "met": 5.8},
  {"activity": "Bicycling 9.4 mph", "met": 5.8},
  {"activity": "Moving furniture", "met": 5.8},
  {"activity": "Bench pressing", "met": 6.0},
  {"activity": "Cheerleading", "met": 6.0},
  {"activity": "Leisurely swimming", "met": 6.0},
  {"activity": "Wrestling", "met": 6.0},
  {"activity": "Water skiing", "met": 6.0},
  {"activity": "Fencing", "met": 6.0},
  {"activity": "Deadlifts", "met": 6.0},
  {"activity": "Vigorous yard work", "met": 6.0},
  {"activity": "Shoveling snow", "met": 6.0},
  {"activity": "Jazzercise", "met": 6.0},
  {"activity": "Weight lifting", "met": 6.0},
  {"activity": "Jog/walk combo", "met": 6.0},
  {"activity": "Cross country hiking", "met": 6.0},
  {"activity": "Vigorously chopping wood", "met": 6.3},
  {"activity": "Climbing hills", "met": 6.3},
  {"activity": "Basketball", "met": 6.5},
  {"activity": "Zumba", "met": 6.5},
  {"activity": "Bicycling 10-11.9 mph", "met": 6.8},
  {"activity": "Ski machine", "met": 6.8},
  {"activity": "Slow cross country skiing", "met": 6.8},
  {"activity": "Stationary bicycle", "met": 7.0},
  {"activity": "Jet skiing", "met": 7.0},
  {"activity": "Roller skaing", "met": 7.0},
  {"activity": "Jogging", "met": 7.0},
  {"activity": "Kickball", "met": 7.0},
  {"activity": "Backpacking", "met": 7.0},
  {"activity": "Racquetball", "met": 7.0},
  {"activity": "Ice skating", "met": 7.0},
  {"activity": "Soccer", "met": 7.0},
  {"activity": "Sking", "met": 7.0},
  {"activity": "Sledding", "met": 7.0},
  {"activity": "High impact aerobics", "met": 7.3},
  {"activity": "Tennis", "met": 7.3},
  {"activity": "Step aerobics with 6”-8” step", "met": 7.5},
  {"activity": "Vigorous snow shoveling", "met": 7.5},
  {"activity": "Carrying groceries upstairs", "met": 7.5},
  {"activity": "Line dancing", "met": 7.8},
  {"activity": "Field hockey", "met": 7.8},
  {"activity": "Lacrosse", "met": 8.0},
  {"activity": "Synchronized swimming", "met": 8.0},
  {"activity": "Rock climbing", "met": 8.0},
  {"activity": "Flag football", "met": 8.0},
  {"activity": "Jogging in place", "met": 8.0},
  {"activity": "Bicycling 12-13.9 mph", "met": 8.0},
  {"activity": "Ice hockey", "met": 8.0},
  {"activity": "Jump squats", "met": 8.0},
  {"activity": "Running a 12 min/mile", "met": 8.3},
  {"activity": "Rugby", "met": 8.3},
  {"activity": "BMX", "met": 8.5},
  {"activity": "Spin class", "met": 8.5},
  {"activity": "Mountain biking", "met": 8.5},
  {"activity": "Vigorous stationary rowing", "met": 8.5},
  {"activity": "Fast pace stair climbing", "met": 8.8},
  {"activity": "Slow pace rope jumping", "met": 8.8},
  {"activity": "Cross country running", "met": 9.0},
  {"activity": "Basketball drills", "met": 9.3},
  {"activity": "Step aerobics with 10”-12” step", "met": 9.5},
  {"activity": "Kettlebell swings", "met": 9.8},
  {"activity": "Swimming laps vigorously", "met": 9.8},
  {"activity": "Running 10 min/mile", "met": 9.8},
  {"activity": "Treading water, fast", "met": 9.8},
  {"activity": "Rollerblading moderate pace", "met": 9.8},
  {"activity": "Water polo", "met": 10.0},
  {"activity": "Bicycling 14-15.9 mph", "met": 10.0},
  {"activity": "Aerobics while wearing 10-15 lb weights", "met": 10.0},
  {"activity": "Kickboxing", "met": 10.3},
  {"activity": "Tae kwan do", "met": 10.3},
  {"activity": "Running 9 min/mile", "met": 10.5},
  {"activity": "Skipping rope", "met": 11.0},
  {"activity": "Slide board exercises", "met": 11.0},
  {"activity": "Running 8 min/mile", "met": 11.8},
  {"activity": "Moderate pace rope jumping", "met": 11.8},
  {"activity": "Bicycling 16-19 mph", "met": 12.0},
  {"activity": "Very vigorous stationary rowing", "met": 12.0},
  {"activity": "Fast rope jumping", "met": 12.3},
  {"activity": "Running 7 min/mile", "met": 12.3},
  {"activity": "Fast pace rollerblading", "met": 12.3},
  {"activity": "Vigorous kayaking", "met": 12.5},
  {"activity": "Brisk cross country skiing", "met": 12.5},
  {"activity": "Boxing", "met": 12.8},
  {"activity": "Marathon running", "met": 13.3},
  {"activity": "Speed skating", "met": 13.3},
  {"activity": "Ice dancing", "met": 14.0},
  {"activity": "Running 6 min/mile", "met": 14.5},
  {"activity": "Running stairs", "met": 15.0},
  {"activity": "Bicycling > 20 mph", "met": 15.8},
  {"activity": "Running 5 min/mile", "met": 19.0},
];

const function = FunctionObject(
  name: 'set_activity_mets',
  description: '활동별 MET 테이블을 모델에 주입합니다.',
  parameters: {
    "type": "object",
    "properties": {
      "items": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "activity": {"type": "string"},
            "met": {"type": "number"},
          },
          "required": ["activity", "met"],
        },
      },
    },
    "required": ["items"],
  },
);

const tool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: function,
);

Future<String> estimateMet(String activity) async {
  // 툴 호출 강제
  final res1 = await client.createChatCompletion(
    request: CreateChatCompletionRequest(
      model: const ChatCompletionModel.model(ChatCompletionModels.gpt5),
      messages: [
        const ChatCompletionMessage.developer(
          content: ChatCompletionDeveloperMessageContent.text(
            'Load Met table, then answer user query.',
          ),
        ),
      ],
      tools: [tool],
      toolChoice: ChatCompletionToolChoiceOption.tool(
        ChatCompletionNamedToolChoice(
          type: ChatCompletionNamedToolChoiceType.function,
          function: ChatCompletionFunctionCallOption(name: function.name),
        ),
      ),
    ),
  );

  final toolCall = res1.choices.first.message.toolCalls?.first;
  if (toolCall == null) return '';

  final res2 = await client.createChatCompletion(
    request: CreateChatCompletionRequest(
      model: const ChatCompletionModel.model(ChatCompletionModels.gpt5),
      messages: [
        const ChatCompletionMessage.developer(
          content: ChatCompletionDeveloperMessageContent.text(
            'Load MET Table, then answer user query.',
          ),
        ),
        ChatCompletionMessage.assistant(
          toolCalls: res1.choices.first.message.toolCalls,
        ),
        ChatCompletionMessage.tool(
          content: jsonEncode({'items': metTable}),
          toolCallId: toolCall.id,
        ),
        ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(
            'Estimate the MET value for "$activity". '
            'Return "<number> - <one sentence reason>".',
          ),
        ),
      ],
      tools: [tool],
    ),
  );

  return res2.choices.first.message.content?.toString() ?? '';
}

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});
  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  final _c = TextEditingController();
  String _out = '';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI MET 추정')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '활동 (예: 2km 등교)',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy
                  ? null
                  : () async {
                      final q = _c.text.trim();
                      if (q.isEmpty) return;
                      setState(() => _busy = true);
                      final r = await estimateMet(q);
                      setState(() {
                        _out = r;
                        _busy = false;
                      });
                    },
              child: Text(_busy ? '실행 중...' : '실행'),
            ),
            const SizedBox(height: 12),
            SelectableText(_out),
          ],
        ),
      ),
    );
  }
}
