import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:tasktune/env/env.dart';

const String metTable = '''
Sleeping
.95
Meditating
1.0
Watching TV while sitting
1.3
Playing board games
1.5
Watering your lawn
1.5
Playing chess
1.5
Washing dishes
1.8
Ironing
1.8
Doing laundry
2.0
Ice fishing
2.0
Very slow walking
2.0
Nadisodhana yoga
2.0
Stretching
2.3
Dusting
2.3
Grocery shopping
2.3
Hatha yoga
2.5
Carrying out the trash
2.5
Camping
2.5
Standing
2.5
Snow blowing
2.5
Putting away groceries
2.5
Bow hunting
2.5
Watering plants 
2.5
Slow pace walking
2.8
Slow dancing
3.0
Walking the dog
3.0
Hammering nails
3.0
Light yard work
3.0
Pilates
3.0
Diving
3.0
Washing windows
3.2
Sweeping
3.3
Walking downhill
3.3
Cooking dinner
3.3
Making your bed
3.3
Vacuuming
3.3
Squat using squat machine
3.5
Fishing
3.5
Mopping
3.5
Moderate speed walking
3.5
Bicycling 5.5 mph
3.5
Cleaning the garage
3.5
Giving the dog a bath
3.5
Using leaf blower
3.5
Walking moderate pace
3.5
Buildling a fence
3.8
Gymnastics
3.8
Raking leaves
3.8
Bowling
3.8
Trimming shrubs and trees
4.0
Paddleboat
4.0
Volleyball
4.0
Curling
4.0
Circuit training
4.3
Brisk speed walking
4.3
Slow pace stair climbing
4.4
Weeding your garden 
4.5
Crab fishing
4.5
Chopping wood
4.5
Planting trees
4.5
Removing carpet
4.5
Rowing, stationary
4.8
Tap
4.8
Golf
4.8
Cricket
4.8
Skateboarding
5.0
Cleaning your gutters
5.0
Ballet
5.0
Elliptical trainer
5.0
Unicycling 
5.0
Boot camp training
5.0
Low impact aerobics
5.0
Laying sod
5.0
Baseball
5.0
Softball 
5.0
Moderate snow shoveling
5.3
Water aerobics
5.3
Ballroom dancing
5.5
Horseback riding
5.5
Step aerobics with 4” step
5.5
Mowing the lawn
5.5
Water aerobics
5.5
Squats with resistance band
5.5
Marching band
5.5
Swimming laps, moderate
5.8
Moderate rowing
5.8
Dodgeball
5.8
Bicycling 9.4 mph
5.8
Moving furniture
5.8
Bench pressing
6.0
Cheerleading
6.0
Leisurely swimming
6.0
Wrestling
6.0
Water skiing
6.0
Fencing
6.0
Deadlifts
6.0
Vigorous yard work
6.0
Shoveling snow
6.0
Jazzercise
6.0
Weight lifting
6.0
Jog/walk combo
6.0
Cross country hiking
6.0
Vigorously chopping wood
6.3
Climbing hills
6.3
Basketball 
6.5
Zumba
6.5
Bicycling 10-11.9 mph
6.8
Ski machine
6.8
Slow cross country skiing
6.8
Stationary bicycle
7.0
Jet skiing
7.0
Roller skaing
7.0
Jogging
7.0
Kickball
7.0
Backpacking
7.0
Racquetball
7.0
Ice skating
7.0
Soccer
7.0
Sking
7.0
Sledding
7.0
High impact aerobics
7.3
Tennis
7.3
Step aerobics with 6”-8” step
7.5
Vigorous snow shoveling
7.5
Carrying groceries upstairs
7.5
Line dancing
7.8
Field hockey
7.8
Lacrosse
8.0
Synchronized swimming
8.0
Rock climbing
8.0
Flag football
8.0
Jogging in place
8.0
Bicycling 12-13.9 mph
8.0
Ice hockey
8.0
Jump squats
8.0
Running a 12 min/mile
8.3
Rugby
8.3
BMX
8.5
Spin class
8.5
Mountain biking 
8.5
Vigorous stationary rowing 
8.5
Fast pace stair climbing
8.8
Slow pace rope jumping 
8.8
Cross country running
9.0
Basketball drills
9.3
Step aerobics with 10”-12” step
9.5
Kettlebell swings
9.8
Swimming laps vigorously
9.8
Running 10 min/mile
9.8
Treading water, fast
9.8
Rollerblading moderate pace
9.8
Water polo
10.0
Bicycling 14-15.9 mph
10.0
Aerobics while wearing 10-15 lb weights
10.0
Kickboxing
10.3
Tae kwan do
10.3
Running 9 min/mile
10.5
Skipping rope
11.0
Slide board exercises
11.0
Running 8 min/mile
11.8
Moderate pace rope jumping
11.8
Bicycling 16-19 mph
12.0
Very vigorous stationary rowing 
12.0
Fast rope jumping 
12.3
Running 7 min/mile
12.3
Fast pace rollerblading
12.3
Vigorous kayaking
12.5
Brisk cross country skiing
12.5
Boxing
12.8
Marathon running
13.3
Speed skating
13.3
Ice dancing
14.0
Running 6 min/mile
14.5
Running stairs
15.0
Bicycling > 20 mph
15.8
Running 5 min/mile
19.0
''';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  String result = "아직 분석되지 않았어요.";
  bool loading = false;
  final TextEditingController _controller = TextEditingController();

  Future<void> _analyzeFatigue(String activity) async {
    final prompt =
        '''
Given the following MET table of physical activities:

$metTable

Estimate the MET value for: "$activity".
Return only the numeric MET (e.g., 3.5) and a one-sentence explanation.
''';

    setState(() => loading = true);
    try {
      OpenAI.apiKey = Env.apiKey;
      final response = await OpenAI.instance.chat.create(
        model: "gpt-4o-mini",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
          ),
        ],
        temperature: 0.2,
      );

      final messageContent = response.choices.first.message.content;
      final content = (messageContent != null && messageContent.isNotEmpty)
          ? messageContent.first.text
          : "결과를 불러오지 못했습니다.";

      setState(() => result = content ?? "결과를 불러오지 못했습니다.");
    } catch (e) {
      setState(() => result = "오류 발생: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'AI MET 추정',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '활동 설명을 입력하세요 (예: 2km 등교)',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loading
                ? null
                : () => _analyzeFatigue(_controller.text.trim()),
            child: Text(loading ? "분석 중..." : "MET 추정 실행"),
          ),
          const SizedBox(height: 24),
          Text(result),
        ],
      ),
    );
  }
}
