import 'package:flutter/material.dart';

void main() => runApp(const QadoraAiApp());

const _ink = Color(0xFF100D19);
const _panel = Color(0xFF191425);
const _purple = Color(0xFF8B5CF6);
const _gold = Color(0xFFE5C47B);

class QadoraAiApp extends StatelessWidget {
  const QadoraAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'قدور AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _ink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _purple,
          brightness: Brightness.dark,
          surface: _panel,
        ),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const ChatHome(),
    );
  }
}

class ChatMessage {
  ChatMessage(this.text, {required this.fromUser});
  final String text;
  final bool fromUser;
}

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _showHistory = false;

  void _send([String? suggested]) {
    final text = (suggested ?? _controller.text).trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text, fromUser: true));
      _messages.add(ChatMessage(
        'أهلاً بك! واجهة قدور AI جاهزة. في المرحلة التالية سنوصل المحادثة بمحرك الذكاء الاصطناعي الحقيقي حتى أقدر أجاوبك على سؤالك.',
        fromUser: false,
      ));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (wide || _showHistory) _historyPanel(wide),
              Expanded(
                child: Column(
                  children: [
                    _topBar(wide),
                    Expanded(
                      child: _messages.isEmpty
                          ? _welcome()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) =>
                                  _messageBubble(_messages[index]),
                            ),
                    ),
                    _composer(),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12, top: 7),
                      child: Text(
                        'قدور AI قد يخطئ أحياناً؛ راجع المعلومات المهمة.',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(bool wide) => Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          children: [
            if (!wide)
              IconButton(
                onPressed: () => setState(() => _showHistory = !_showHistory),
                icon: const Icon(Icons.menu_rounded),
              ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: const LinearGradient(colors: [_purple, Color(0xFF5435A1)]),
              ),
              child: const Icon(Icons.auto_awesome, color: _gold),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('قدور AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('مساعدك الذكي', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF183326),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, size: 7, color: Color(0xFF55D68B)),
                  SizedBox(width: 6),
                  Text('جاهز', style: TextStyle(color: Color(0xFF8BE0AE), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _historyPanel(bool wide) => Container(
        width: wide ? 260 : 230,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: _panel,
          border: Border(left: BorderSide(color: Colors.white10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('قدور AI', style: TextStyle(color: _gold, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: _purple, padding: const EdgeInsets.all(13)),
              onPressed: () => setState(() { _messages.clear(); _showHistory = false; }),
              icon: const Icon(Icons.add),
              label: const Text('محادثة جديدة'),
            ),
            const SizedBox(height: 22),
            const Text('مساحة العمل', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 12),
            _sideItem(Icons.chat_bubble_outline, 'المحادثات'),
            _sideItem(Icons.image_outlined, 'تحليل الصور قريباً'),
            _sideItem(Icons.folder_open_outlined, 'الملفات قريباً'),
            const Spacer(),
            const Divider(color: Colors.white12),
            _sideItem(Icons.settings_outlined, 'الإعدادات'),
            const Text('الإصدار التجريبي 0.1.0', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white30, fontSize: 10)),
          ],
        ),
      );

  Widget _sideItem(IconData icon, String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          Icon(icon, size: 18, color: Colors.white60),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
      );

  Widget _welcome() => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF281D40),
                    border: Border.all(color: _purple.withValues(alpha: .6)),
                    boxShadow: [BoxShadow(color: _purple.withValues(alpha: .18), blurRadius: 35)],
                  ),
                  child: const Icon(Icons.auto_awesome, size: 37, color: _gold),
                ),
                const SizedBox(height: 24),
                const Text('مرحباً بك في قدور AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('شنو الداير تعرفه أو تنجزه اليوم؟',
                    style: TextStyle(color: Colors.white60, fontSize: 15)),
                const SizedBox(height: 30),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _suggestion(Icons.lightbulb_outline, 'اشرح لي موضوعاً صعباً'),
                    _suggestion(Icons.code, 'ساعدني في كتابة كود'),
                    _suggestion(Icons.edit_note, 'اكتب لي رسالة احترافية'),
                    _suggestion(Icons.translate, 'ترجم لي نصاً'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _suggestion(IconData icon, String text) => ActionChip(
        onPressed: () => _send(text),
        avatar: Icon(icon, size: 17, color: _gold),
        label: Text(text),
        backgroundColor: _panel,
        side: const BorderSide(color: Colors.white12),
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      );

  Widget _messageBubble(ChatMessage message) => Align(
        alignment: message.fromUser ? Alignment.centerStart : Alignment.centerEnd,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 650),
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: message.fromUser ? const Color(0xFF30234A) : _panel,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(message.text, style: const TextStyle(fontSize: 14, height: 1.7)),
        ),
      );

  Widget _composer() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Container(
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك إلى قدور AI...',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 17),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton.filled(
                    onPressed: _send,
                    style: IconButton.styleFrom(backgroundColor: _purple),
                    icon: const Icon(Icons.arrow_upward_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
