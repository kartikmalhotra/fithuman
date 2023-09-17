import 'package:flutter/material.dart';
import 'package:brainfit/const/app_constants.dart';

class AssessmentInfoScreen extends StatefulWidget {
  final String showInfoForString;
  AssessmentInfoScreen({Key? key, required this.showInfoForString})
      : super(key: key);

  @override
  State<AssessmentInfoScreen> createState() => _AssessmentInfoScreenState();
}

class _AssessmentInfoScreenState extends State<AssessmentInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(widget.showInfoForString,
            style: Theme.of(context).textTheme.headline6),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            if (widget.showInfoForString == "Promoter") ..._showPromoterText(),
            if (widget.showInfoForString == "Controller")
              ..._showControllerText(),
            if (widget.showInfoForString == "Analyzer") ..._showAnalyzerText(),
            if (widget.showInfoForString == "Supporter")
              ..._showSupporterText(),
          ],
        ),
      ),
    );
  }

  List<Widget> _showAnalyzerText() {
    return [
      Text("The True-Blue Analyzer",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
          "The True Blue Analyzer is  accurate, precise, detail-oriented, and conscientious. “True Blue” represents stability and careful decision making. When in the analyzer mode, people think analytically and systematically, and carefully make decisions with plenty of research and information to back it up. This mode often creates high standards for themselves and others. By being able to focus on the details, they often see what others do not and are creative and effective problem solvers.",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
      SizedBox(height: 50.0),
      Text("The True-Blue Analyzer - What Doesn’t Work",
          style: Theme.of(context).textTheme.subtitle1!),
      SizedBox(height: 20.0),
      Text(
        "Analyzers can become passive to avoid conflict. They may find it difficult to verbalize their feelings and have difficulty mirroring the feelings of those around them. Highly emotional people will bother Analyzers, because they perceive them to lack objectivity and orderly thinking. They dislike being around people who seem to be “full of hype,” but rather seek people who value facts, accuracy, and logic.",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
      ),
      Text(
          "Analyzers require clear-cut boundaries in order to feel comfortable at work, in relationships, or take action. They sometimes may feel bound by procedures and methods and find it difficult to stray from order. Analyzers often lack a sense of adventure and feel more comfortable staying home in more familiar surroundings which can lead to feeling like they’ve fallen into a rut.",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
      SizedBox(height: 50.0),
      Text("The True-Blue Analyzer - What Works",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
          "The Analyzer mode works well when movement and momentum is needed. They will organize systems with logic, and accuracy while striving for an excellent outcome. Analyzers focus and ask important questions that can bring about breakthrough solutions to seemingly impossible problems. They will jump in and do what it takes, even if they must do it alone, in order to see something to completion. They emphasize quality and strive for a diplomatic approach and consensus within groups. The result is action, teamwork, and progress.",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
      Text(
          "As an Analyzer, I tend to evaluate all the information before I make a choice. Because my family told me our trip from Iran to America was a vacation when it actually was a permanent move, I had a hard time trusting that people were telling me the full story, and would set out to find the truth. The positive side of my being an Analyzer is my ability to be detail oriented. In business, I am intimately aware of profit margins, return on capital investments, and can see and hear things other people miss. When it works, the Analyzer trait is beneficial both in business and personal relationships.",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
    ];
  }

  List<Widget> _showControllerText() {
    return [
      Text("The Power-Red Controller",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
          "The Controller exhibits a goal-oriented, no-nonsense approach to solutions. They make great executives since they are able to make quick decisions, take action and move on. The color for the Controller is “Power-tie Red” for their ability to lead others as opposed to following them. The Controller, sometimes called a driver, needs to feel in charge of their life, possibly because their family life was highly unpredictable causing them to feel insecure or unsafe. Controllers are not concerned with details, but delegate the implementation of plans to others. They are often self-starters and lean into taking on leadership and management roles. We all need to know how and when to tap into Controller mode to get the job done.",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
      SizedBox(height: 50.0),
      Text("The Power-Red Controller - What Doesn’t Work",
          style: Theme.of(context).textTheme.subtitle1!),
      SizedBox(height: 20.0),
      Text(
          "Since Controllers tend to take charge, they often don't trust others’ ability to move a vision forward and don’t listen or entertain alternate opinions. When in Controller mode, their dislike for repetition and routine may cause them to ignore important details. Their pursuit of grand visions may cause them to spread themselves thin by attempting too much at one time resulting in disappointing results. A need for control can cause them to react in fearful anger followed by a feeling of shame at their behavior. When a Controller insists on having their way, employees, family members, or friend groups will either acquiesce and let them lead, or leave the relationship.",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
      SizedBox(height: 50.0),
      Text("The Power-Red Controller - What Works",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
          "Tapping into Controller mode can help move others toward decision making, maintain focus on goals, and achieve tangible results. The Controller or “driver” mode is appropriate when decisive action is needed because it enables people to rise to the occasion, especially in a moment of crisis. They can tap into high self-confidence and become risk-takers and problem-solvers on whom others can rely for direction and decisions. Controller mode allows people to speak directly without needing the approval of others. Stress and heavy workload is openly welcomed by those in Controller mode because of their ability to meet new challenges and risk without fear",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
    ];
  }

  List<Widget> _showPromoterText() {
    return [
      Text("The Purple Promoter",
          style: Theme.of(context).textTheme.subtitle1!),
      SizedBox(height: 20.0),
      Text(
          "The Promoter is enthusiastic, optimistic, talkative, persuasive, impulsive, and emotionally expressive. When in this mode, they enjoy being “the life of the party” and center of attention. The color for the Promoter is ….Orange for its high energy and vibrancy. Promoters are good relationship builders, and often instantly well-liked. They enjoy being around others, and work well in teams and groups. Promoters are admired for their achievements and enjoy being publicly acknowledged.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      SizedBox(height: 50.0),
      Text("The Purple Promoter - What Doesn’t Work",
          style: Theme.of(context).textTheme.bodyText1!),
      SizedBox(height: 20.0),
      Text(
          "When in Promoter mode, people often make impulsive decisions rather than taking the time for research and contemplative thinking. They may find themselves over-promising by taking on more than they can accomplish and have difficulty following through on tasks. Promoters can benefit by breaking big goals into smaller more achievable goals and being encouraged as they make small-step progress.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      Text(
          "Fear of Missing Out (FOMO) is often a stumbling block to the Promoter as they often jump from one opportunity or relationship to another, thinking the “grass is greener on the other side.” They may feel that staying in Promoter mode provides a sense of safety as they refrain from being deeply intimate with any one thing or person. However, this mode often prevents them from cultivating intimate and connected relationships.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      SizedBox(height: 50.0),
      Text("The Purple Promoter - What Works",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
          "Many people find the Promoter inspiring as they are highly engaging communicators who are able to enroll others in their ideas. They work well with others and their positive outlook and enthusiasm - especially when unexpected issues arise - makes them sought-after leaders. When tapping into this mode, the Promoter is an effective presenter, motivator, and problem-solver. However, their great conversation skills might cause them to dominate the conversation. By exercising self control, promoters can become good listeners, and better regulate their actions, words, and emotions.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      Text(
          "My wife Shanda easily accesses the Promoter mode. It’s one of the reasons she is such a fantastic marketer in business. Once she believes something is going to have a positive result, she will want to share how amazing it is with the world. For example, she organized us getting an intravenous supplement to improve our overall health and wellbeing. She was convinced of the benefits of this protocol and afterwards talked about it with everyone she met. On the other hand, as someone who leans into Analyzer mode, I tend to be more cynical. I prefer to look at the results over time, test them, and wait some more before being fully convinced - which can make me lose the window of opportunity.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
    ];
  }

  List<Widget> _showSupporterText() {
    return [
      Text("The Mellow-Yellow Supporter",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
          "When tapping into the Supporter mode, people are steady, stable, and predictable. The color for a Supporter is “Mellow Yellow” which represents their preference for a slower, easier pace in their work and personal life. When in Supporter mode, people are attentive and sympathetic listeners. They are generous with their time and resources and are quick to help out their friends. Supporters value relationships which are reflected in their care and keeping of them. They seek security and longevity on the job and are very happy doing a repetitive task making them skilled experts in their field.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      SizedBox(height: 50.0),
      Text("The Mellow-Yellow Supporter - What Doesn’t work",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
          "People in Supporter mode like routines - and resist change - in order to maintain a sense of security. Even if the supporter is living in an unpleasant situation, they may worry that to change it could be worse. Supporters eventually will adopt change, but will require an explanation of why the change is occurring, and need time to adapt.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      Text(
          "In relationships, a Supporter’s desire for closeness in relationships may be perceived as possessive to their friends and partners. They are often sensitive to criticism - both giving and receiving. Supporters have a desire to please others and may find it difficult to say \"no\" or establish boundaries. When in this mode, their passiveness in avoiding conflict can lead to them feeling frustrated, resentful and holding a grudge.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      SizedBox(height: 50.0),
      Text("The Mellow-Yellow Supporter - What Works",
          style: Theme.of(context).textTheme.subtitle1),
      SizedBox(height: 20.0),
      Text(
        "When people choose Supporter mode, they are able to create a collaborative and positive team environment. Peacemaking is a superpower to them, as they are able to bring patience, attention, and an even-temper to groups in conflict.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
      ),
      Text(
          "Supporters are grounded in reality and common sense and able to see clearly the practical ways to accomplish their goals. They can lean into their steady and methodical side and even tackle many tasks simultaneously, yet see each one to completion. When in Supporter mode, they can visualize a goal from a high vantage point, and map out the individual steps to get there. Supporters are crucial to society because of their desire to give of their time and resources to serve others or a cause.",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14)),
      Text(
        "I learned to feel comfortable operating in Supporter mode because of my experience taking care of my sister who is nine years younger. Since my parents both worked, I walked my sister to school everyday, attended all her basketball games and even volunteered to become an assistant coach. However, people in supporter mode can often feel they are taking care of others to the exclusion of their own desires, and feel resentful when their needs are not met.",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
      )
    ];
  }
}
