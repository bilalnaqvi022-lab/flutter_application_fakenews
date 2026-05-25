//import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FakeNewsScannerApp());
}

// ─────────────────────────────────────────────
//  THEME & CONSTANTS
// ─────────────────────────────────────────────
class AppColors {
  static const background   = Color(0xFF080C14);
  static const surface      = Color(0xFF0F1623);
  static const surfaceHigh  = Color(0xFF161D2E);
  static const border       = Color(0xFF1E2A42);
  static const accent       = Color(0xFF00D4FF);
  static const accentGlow   = Color(0x3300D4FF);
  static const verified     = Color(0xFF00E87A);
  static const verifiedGlow = Color(0x3300E87A);
  static const doubtful     = Color(0xFFFFB020);
  static const doubtfulGlow = Color(0x33FFB020);
  static const fake         = Color(0xFFFF3B5C);
  static const fakeGlow     = Color(0x33FF3B5C);
  static const textPrimary  = Color(0xFFE8EDF5);
  static const textSecondary= Color(0xFF6B7FA3);
  static const textMuted    = Color(0xFF3D4F6E);
}

class AppTextStyles {
  static const _base = TextStyle(color: AppColors.textPrimary);
  static final displayLarge  = _base.copyWith(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5);
  static final displayMedium = _base.copyWith(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3);
  static final titleLarge    = _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);
  static final titleMedium   = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4);
  static final bodyLarge     = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6);
  static final bodyMedium    = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.textSecondary);
  static final labelLarge    = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.8);
  static final mono          = const TextStyle(fontSize: 12, color: AppColors.accent, letterSpacing: 0.5);
}

// ─────────────────────────────────────────────
//  ROOT APP
// ─────────────────────────────────────────────
class FakeNewsScannerApp extends StatelessWidget {
  const FakeNewsScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake News Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _fadeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _fadeAnim  = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));

    Future.delayed(const Duration(seconds: 3), () {
      _fadeCtrl.forward().then((_) {
        if (mounted) {
          Navigator.pushReplacement(context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionDuration: const Duration(milliseconds: 600),
                transitionsBuilder: (_, anim, __, child) =>
                    FadeTransition(opacity: anim, child: child),
              ));
        }
      });
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (_, __) => Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGlow,
                      border: Border.all(color: AppColors.accent, width: 1.5),
                      boxShadow: [BoxShadow(color: AppColors.accentGlow, blurRadius: 40, spreadRadius: 10)],
                    ),
                    child: const Icon(Icons.document_scanner_rounded, color: AppColors.accent, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text('FAKE NEWS SCANNER', style: AppTextStyles.mono.copyWith(fontSize: 15, letterSpacing: 3)),
              const SizedBox(height: 8),
              Text('AI-Powered Truth Verification', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 48),
              SizedBox(
                width: 160,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 3),
                  builder: (_, v, __) => LinearProgressIndicator(
                    value: v,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MODELS
// ─────────────────────────────────────────────
enum CredibilityLevel { verified, doubtful, fake, unknown }
enum AppLanguage { english, urdu }
enum ScanState { idle, capturing, processing, result, error }

class ScanResult {
  final String extractedText;
  final CredibilityLevel credibility;
  final double score;          // 0.0 – 1.0
  final List<VerifiedSource> sources;
  final String explanation;
  final List<String> detectedClaims;
  final DateTime scannedAt;

  const ScanResult({
    required this.extractedText,
    required this.credibility,
    required this.score,
    required this.sources,
    required this.explanation,
    required this.detectedClaims,
    required this.scannedAt,
  });
}

class VerifiedSource {
  final String title;
  final String publisher;
  final String url;
  final bool supports;

  const VerifiedSource({
    required this.title,
    required this.publisher,
    required this.url,
    required this.supports,
  });
}

// ─────────────────────────────────────────────
//  HOME SCREEN
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  ScanState _state  = ScanState.idle;
  AppLanguage _lang = AppLanguage.english;
  ScanResult? _result;
  int _historyCount = 3;

  late AnimationController _scanLineCtrl;
  late Animation<double>   _scanLineAnim;

  @override
  void initState() {
    super.initState();
    _scanLineCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _scanLineAnim = CurvedAnimation(parent: _scanLineCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scanLineCtrl.dispose();
    super.dispose();
  }

  void _simulateScan() async {
    setState(() => _state = ScanState.capturing);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _state = ScanState.processing);
    await Future.delayed(const Duration(seconds: 2));

    // Simulated result – replace with real OCR + API call
    final results = [
      ScanResult(
        extractedText: 'Scientists confirm new vaccine eliminates all viruses permanently with zero side effects. '
            'Government suppresses the news to protect pharmaceutical profits.',
        credibility: CredibilityLevel.fake,
        score: 0.08,
        detectedClaims: [
          'Vaccine eliminates all viruses permanently',
          'Zero side effects confirmed',
          'Government suppressing cure',
        ],
        explanation: _lang == AppLanguage.urdu
            ? 'یہ خبر جھوٹی ہے۔ کوئی بھی ویکسین تمام وائرسوں کو مستقل طور پر ختم نہیں کرتی۔ یہ دعوے طبی ثبوت کے بغیر ہیں۔'
            : 'This article contains multiple false claims. No vaccine eliminates all viruses permanently. '
                'The "government suppression" narrative is a common misinformation pattern with no credible evidence.',
        sources: const [
          VerifiedSource(title: 'WHO Vaccine Safety Report 2024', publisher: 'World Health Organization', url: 'https://who.int', supports: false),
          VerifiedSource(title: 'CDC Immunization Research', publisher: 'CDC', url: 'https://cdc.gov', supports: false),
          VerifiedSource(title: 'Reuters Fact Check', publisher: 'Reuters', url: 'https://reuters.com/fact-check', supports: false),
        ],
        scannedAt: DateTime.now(),
      ),
      ScanResult(
        extractedText: 'The State Bank of Pakistan has raised the interest rate by 1.5% in response to inflation pressures.',
        credibility: CredibilityLevel.verified,
        score: 0.94,
        detectedClaims: ['State Bank raises interest rate by 1.5%', 'Response to inflation pressures'],
        explanation: _lang == AppLanguage.urdu
            ? 'یہ خبر درست ہے۔ اسٹیٹ بینک نے شرح سود میں اضافے کا اعلان کیا۔'
            : 'This claim is verified. The State Bank of Pakistan officially announced the rate hike. '
                'Multiple credible financial sources confirm this information.',
        sources: const [
          VerifiedSource(title: 'SBP Official Press Release', publisher: 'State Bank of Pakistan', url: 'https://sbp.org.pk', supports: true),
          VerifiedSource(title: 'Bloomberg Pakistan Economy', publisher: 'Bloomberg', url: 'https://bloomberg.com', supports: true),
        ],
        scannedAt: DateTime.now(),
      ),
      ScanResult(
        extractedText: 'Local government plans to expand metro rail to three new districts by 2026, officials say.',
        credibility: CredibilityLevel.doubtful,
        score: 0.51,
        detectedClaims: ['Metro rail expansion to 3 districts', 'Timeline: 2026'],
        explanation: _lang == AppLanguage.urdu
            ? 'یہ خبر مشکوک ہے۔ کچھ ذرائع نے اس کی تصدیق کی ہے لیکن سرکاری اعلان ابھی نہیں ہوا۔'
            : 'This claim is partially supported. While expansion talks are confirmed, the specific 2026 timeline '
                'and three districts claim lacks official confirmation. Treat with caution.',
        sources: const [
          VerifiedSource(title: 'City Transport Authority Briefing', publisher: 'Govt. Transport Dept.', url: 'https://example.gov', supports: true),
          VerifiedSource(title: 'Dawn News Analysis', publisher: 'Dawn', url: 'https://dawn.com', supports: false),
        ],
        scannedAt: DateTime.now(),
      ),
    ];

    setState(() {
      _result = results[Random().nextInt(results.length)];
      _state  = ScanState.result;
      _historyCount++;
    });
  }

  void _reset() => setState(() { _state = ScanState.idle; _result = null; });

  // ── UI helpers
  Color _credColor(CredibilityLevel l) {
    switch (l) {
      case CredibilityLevel.verified: return AppColors.verified;
      case CredibilityLevel.doubtful: return AppColors.doubtful;
      case CredibilityLevel.fake:     return AppColors.fake;
      default:                        return AppColors.textSecondary;
    }
  }

  Color _credGlow(CredibilityLevel l) {
    switch (l) {
      case CredibilityLevel.verified: return AppColors.verifiedGlow;
      case CredibilityLevel.doubtful: return AppColors.doubtfulGlow;
      case CredibilityLevel.fake:     return AppColors.fakeGlow;
      default:                        return Colors.transparent;
    }
  }

  String _credLabel(CredibilityLevel l) {
    if (_lang == AppLanguage.urdu) {
      switch (l) {
        case CredibilityLevel.verified: return 'تصدیق شدہ';
        case CredibilityLevel.doubtful: return 'مشکوک';
        case CredibilityLevel.fake:     return 'جھوٹی خبر';
        default:                        return 'نامعلوم';
      }
    }
    switch (l) {
      case CredibilityLevel.verified: return 'VERIFIED';
      case CredibilityLevel.doubtful: return 'DOUBTFUL';
      case CredibilityLevel.fake:     return 'FAKE';
      default:                        return 'UNKNOWN';
    }
  }

  IconData _credIcon(CredibilityLevel l) {
    switch (l) {
      case CredibilityLevel.verified: return Icons.verified_rounded;
      case CredibilityLevel.doubtful: return Icons.help_outline_rounded;
      case CredibilityLevel.fake:     return Icons.dangerous_rounded;
      default:                        return Icons.question_mark_rounded;
    }
  }

  // ────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TOP BAR ───────────────────────────────
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentGlow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withOpacity(0.4)),
            ),
            child: const Icon(Icons.document_scanner_rounded, color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_lang == AppLanguage.urdu ? 'فیک نیوز اسکینر' : 'FAKE NEWS SCANNER',
                    style: AppTextStyles.mono.copyWith(fontSize: 13)),
                Text(_lang == AppLanguage.urdu ? 'اے آئی خبر جانچ' : 'AI Truth Verification',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
              ],
            ),
          ),
          // Language toggle
          GestureDetector(
            onTap: () => setState(() {
              _lang = _lang == AppLanguage.english ? AppLanguage.urdu : AppLanguage.english;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('EN', style: AppTextStyles.labelLarge.copyWith(
                    fontSize: 11,
                    color: _lang == AppLanguage.english ? AppColors.accent : AppColors.textMuted,
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(width: 1, height: 12, color: AppColors.border),
                  ),
                  Text('اردو', style: AppTextStyles.labelLarge.copyWith(
                    fontSize: 11,
                    color: _lang == AppLanguage.urdu ? AppColors.accent : AppColors.textMuted,
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // History badge
          Stack(
            children: [
              IconButton(
                onPressed: () => _showHistory(context),
                icon: const Icon(Icons.history_rounded, color: AppColors.textSecondary),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceHigh,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Positioned(
                right: 6, top: 6,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                  child: Center(child: Text('$_historyCount',
                      style: const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.w700))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── BODY SWITCHER ─────────────────────────
  Widget _buildBody() {
    switch (_state) {
      case ScanState.idle:       return _buildIdleScreen();
      case ScanState.capturing:  return _buildCapturingScreen();
      case ScanState.processing: return _buildProcessingScreen();
      case ScanState.result:     return _buildResultScreen();
      case ScanState.error:      return _buildErrorScreen();
    }
  }

  // ─── IDLE SCREEN ────────────────────────────
  Widget _buildIdleScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Hero section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xFF0A1628), Color(0xFF0D1F3C)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _lang == AppLanguage.urdu ? 'خبر کی صداقت جانچیں' : 'Verify News Instantly',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _lang == AppLanguage.urdu
                      ? 'تصویر لیں یا اسکرین شاٹ اپلوڈ کریں — AI فوری جانچ کرے گا'
                      : 'Scan any news article or screenshot with your camera for instant AI fact-checking.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                // Camera viewfinder mock
                _buildScannerViewfinder(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Action buttons
          Row(children: [
            Expanded(child: _buildActionButton(
              icon: Icons.camera_alt_rounded,
              label: _lang == AppLanguage.urdu ? 'کیمرہ' : 'Camera Scan',
              sublabel: _lang == AppLanguage.urdu ? 'تصویر کھینچیں' : 'Take a photo',
              color: AppColors.accent,
              onTap: _simulateScan,
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton(
              icon: Icons.upload_rounded,
              label: _lang == AppLanguage.urdu ? 'اپلوڈ' : 'Upload Image',
              sublabel: _lang == AppLanguage.urdu ? 'فائل منتخب کریں' : 'Gallery / Files',
              color: AppColors.textSecondary,
              onTap: _simulateScan,
            )),
          ]),
          const SizedBox(height: 20),
          // Stats row
          _buildStatsRow(),
          const SizedBox(height: 20),
          // How it works
          _buildHowItWorks(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildScannerViewfinder() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          children: [
            // Corner brackets
            ..._cornerBrackets(),
            // Animated scan line
            AnimatedBuilder(
              animation: _scanLineAnim,
              builder: (_, __) => Positioned(
                top: _scanLineAnim.value * 140 + 8,
                left: 16, right: 16,
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent, AppColors.accent.withOpacity(0.8),
                      AppColors.accent, AppColors.accent.withOpacity(0.8), Colors.transparent,
                    ]),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_rounded, color: AppColors.textMuted, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    _lang == AppLanguage.urdu ? 'خبر یہاں رکھیں' : 'Point camera at news article',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _cornerBrackets() {
    const size = 18.0; const thick = 2.0; const pad = 8.0;
    final corners = [
      [Alignment.topLeft,     const Offset(pad, pad),     true,  true ],
      [Alignment.topRight,    const Offset(-pad, pad),    false, true ],
      [Alignment.bottomLeft,  const Offset(pad, -pad),    true,  false],
      [Alignment.bottomRight, const Offset(-pad, -pad),   false, false],
    ];
    return corners.map((c) {
      
      final off   = c[1] as Offset;
      final left  = c[2] as bool;
      final top   = c[3] as bool;
      return Positioned(
        left:   left  ? off.dx : null,
        right:  !left ? -off.dx : null,
        top:    top   ? off.dy : null,
        bottom: !top  ? -off.dy : null,
        child: SizedBox(width: size, height: size,
          child: CustomPaint(painter: _BracketPainter(left: left, top: top, thick: thick)),
        ),
      );
    }).toList();
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color == AppColors.accent ? AppColors.accent.withOpacity(0.4) : AppColors.border),
          boxShadow: color == AppColors.accent ? [BoxShadow(color: AppColors.accentGlow, blurRadius: 12)] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(label, style: AppTextStyles.titleMedium),
            const SizedBox(height: 2),
            Text(sublabel, style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      ('$_historyCount', _lang == AppLanguage.urdu ? 'اسکین' : 'Scans'),
      ('94%', _lang == AppLanguage.urdu ? 'درستگی' : 'Accuracy'),
      ('2s', _lang == AppLanguage.urdu ? 'وقت' : 'Avg Time'),
    ];
    return Row(
      children: stats.asMap().entries.map((e) {
        final i = e.key; final s = e.value;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: i == 0 ? 0 : 6, right: i == 2 ? 0 : 6),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(children: [
              Text(s.$1, style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent)),
              const SizedBox(height: 2),
              Text(s.$2, style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHowItWorks() {
    final steps = _lang == AppLanguage.urdu
        ? ['📸 تصویر لیں', '🔍 متن نکالیں', '🤖 AI تجزیہ', '✅ نتیجہ دیکھیں']
        : ['📸 Capture', '🔍 OCR Extract', '🤖 AI Analyze', '✅ See Result'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_lang == AppLanguage.urdu ? 'کیسے کام کرتا ہے' : 'How It Works',
            style: AppTextStyles.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: steps.asMap().entries.map((e) {
            final i = e.key;
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      Text(e.value.split(' ')[0], style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(e.value.split(' ').skip(1).join(' '),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 10)),
                    ]),
                  ),
                  if (i < steps.length - 1)
                    const Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 10),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── CAPTURING SCREEN ───────────────────────
  Widget _buildCapturingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPulsingIcon(Icons.camera_alt_rounded, AppColors.accent),
          const SizedBox(height: 24),
          Text(_lang == AppLanguage.urdu ? 'تصویر لی جا رہی ہے...' : 'Capturing image...',
              style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Text(_lang == AppLanguage.urdu ? 'کیمرہ فوکس ہو رہا ہے' : 'Focusing camera',
              style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  // ─── PROCESSING SCREEN ──────────────────────
  Widget _buildProcessingScreen() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPulsingIcon(Icons.psychology_rounded, AppColors.accent),
          const SizedBox(height: 32),
          Text(_lang == AppLanguage.urdu ? 'تجزیہ جاری ہے' : 'Analyzing Content',
              style: AppTextStyles.displayMedium.copyWith(fontSize: 20)),
          const SizedBox(height: 32),
          ..._processingSteps(),
        ],
      ),
    );
  }

  List<Widget> _processingSteps() {
    final steps = _lang == AppLanguage.urdu
        ? ['متن نکالنا (OCR)', 'دعوے تلاش کرنا', 'ڈیٹا بیس سے موازنہ', 'نتیجہ تیار کرنا']
        : ['Extracting text (OCR)', 'Detecting claims (NLP)', 'Comparing databases', 'Generating verdict'];
    return steps.asMap().entries.map((e) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 600 + e.key * 400),
        builder: (_, v, __) => Opacity(
          opacity: v.clamp(0, 1),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                    value: v == 1 ? 1 : null,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(v == 1 ? AppColors.verified : AppColors.accent),
                  ),
                ),
                const SizedBox(width: 12),
                Text(e.value, style: AppTextStyles.bodyLarge.copyWith(fontSize: 13)),
                const Spacer(),
                if (v == 1) const Icon(Icons.check_circle_outline_rounded, color: AppColors.verified, size: 16),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPulsingIcon(IconData icon, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.1),
      duration: const Duration(milliseconds: 900),
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 24, spreadRadius: 4)],
        ),
        child: Icon(icon, color: color, size: 36),
      ),
    );
  }

  // ─── RESULT SCREEN ──────────────────────────
  Widget _buildResultScreen() {
    final r = _result!;
    final c = r.credibility;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Verdict card
          _buildVerdictCard(r, c),
          const SizedBox(height: 16),
          // Score bar
          _buildScoreBar(r, c),
          const SizedBox(height: 16),
          // Extracted text
          _buildExtractedText(r),
          const SizedBox(height: 16),
          // Claims
          _buildClaimsSection(r),
          const SizedBox(height: 16),
          // Explanation
          _buildExplanationCard(r, c),
          const SizedBox(height: 16),
          // Sources
          _buildSourcesSection(r),
          const SizedBox(height: 20),
          // Action row
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.camera_alt_rounded, size: 18),
                label: Text(_lang == AppLanguage.urdu ? 'نئی اسکین' : 'Scan Again'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded, size: 18),
                label: Text(_lang == AppLanguage.urdu ? 'شیئر کریں' : 'Share Result'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVerdictCard(ScanResult r, CredibilityLevel c) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (_, v, __) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [_credColor(c).withOpacity(0.08), AppColors.surface],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _credColor(c).withOpacity(0.4), width: 1.5),
              boxShadow: [BoxShadow(color: _credGlow(c), blurRadius: 20)],
            ),
            child: Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _credColor(c).withOpacity(0.15),
                    border: Border.all(color: _credColor(c).withOpacity(0.5)),
                  ),
                  child: Icon(_credIcon(c), color: _credColor(c), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _lang == AppLanguage.urdu ? 'فیصلہ' : 'VERDICT',
                        style: AppTextStyles.mono.copyWith(fontSize: 10, color: _credColor(c).withOpacity(0.7)),
                      ),
                      Text(
                        _credLabel(c),
                        style: AppTextStyles.displayMedium.copyWith(color: _credColor(c), fontSize: 24),
                      ),
                      Text(
                        '${(r.score * 100).toStringAsFixed(0)}% ${_lang == AppLanguage.urdu ? "اعتمادی سکور" : "Credibility Score"}',
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBar(ScanResult r, CredibilityLevel c) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_lang == AppLanguage.urdu ? 'اعتماد کا پیمانہ' : 'Credibility Scale',
                  style: AppTextStyles.labelLarge.copyWith(fontSize: 12)),
              Text('${(r.score * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.mono.copyWith(color: _credColor(c))),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: r.score),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => Stack(
              children: [
                Container(height: 8, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
                FractionallySizedBox(
                  widthFactor: v,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.fake, AppColors.doubtful, AppColors.verified]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_lang == AppLanguage.urdu ? 'جھوٹا' : 'Fake', style: AppTextStyles.bodyMedium.copyWith(fontSize: 10, color: AppColors.fake)),
              Text(_lang == AppLanguage.urdu ? 'مشکوک' : 'Doubtful', style: AppTextStyles.bodyMedium.copyWith(fontSize: 10, color: AppColors.doubtful)),
              Text(_lang == AppLanguage.urdu ? 'سچا' : 'True', style: AppTextStyles.bodyMedium.copyWith(fontSize: 10, color: AppColors.verified)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedText(ScanResult r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.text_fields_rounded, color: AppColors.accent, size: 16),
            const SizedBox(width: 8),
            Text(_lang == AppLanguage.urdu ? 'نکالا گیا متن' : 'Extracted Text',
                style: AppTextStyles.labelLarge.copyWith(fontSize: 12, color: AppColors.accent)),
          ]),
          const SizedBox(height: 12),
          Text(r.extractedText, style: AppTextStyles.bodyLarge.copyWith(fontSize: 13, height: 1.7)),
        ],
      ),
    );
  }

  Widget _buildClaimsSection(ScanResult r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.manage_search_rounded, color: AppColors.doubtful, size: 16),
            const SizedBox(width: 8),
            Text(_lang == AppLanguage.urdu ? 'پائے گئے دعوے' : 'Detected Claims',
                style: AppTextStyles.labelLarge.copyWith(fontSize: 12, color: AppColors.doubtful)),
          ]),
          const SizedBox(height: 12),
          ...r.detectedClaims.map((claim) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(width: 6, height: 6,
                    decoration: BoxDecoration(color: AppColors.doubtful, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Expanded(child: Text(claim, style: AppTextStyles.bodyLarge.copyWith(fontSize: 12))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(ScanResult r, CredibilityLevel c) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _credColor(c).withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _credColor(c).withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.lightbulb_outline_rounded, color: _credColor(c), size: 16),
            const SizedBox(width: 8),
            Text(_lang == AppLanguage.urdu ? 'AI وضاحت' : 'AI Explanation',
                style: AppTextStyles.labelLarge.copyWith(fontSize: 12, color: _credColor(c))),
          ]),
          const SizedBox(height: 10),
          Text(r.explanation, style: AppTextStyles.bodyLarge.copyWith(fontSize: 13, height: 1.7),
              textDirection: _lang == AppLanguage.urdu ? TextDirection.rtl : TextDirection.ltr),
        ],
      ),
    );
  }

  Widget _buildSourcesSection(ScanResult r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.source_rounded, color: AppColors.accent, size: 16),
            const SizedBox(width: 8),
            Text(_lang == AppLanguage.urdu ? 'تصدیق شدہ ذرائع' : 'Verified Sources',
                style: AppTextStyles.labelLarge.copyWith(fontSize: 12, color: AppColors.accent)),
            const Spacer(),
            Text('${r.sources.length} ${_lang == AppLanguage.urdu ? "ذریعے" : "sources"}',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
          ]),
          const SizedBox(height: 12),
          ...r.sources.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: s.supports ? AppColors.verified.withOpacity(0.3) : AppColors.fake.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (s.supports ? AppColors.verified : AppColors.fake).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    s.supports ? Icons.check_rounded : Icons.close_rounded,
                    color: s.supports ? AppColors.verified : AppColors.fake,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.title, style: AppTextStyles.titleMedium.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(s.publisher, style: AppTextStyles.bodyMedium.copyWith(fontSize: 10)),
                  ],
                )),
                Icon(Icons.open_in_new_rounded, color: AppColors.textMuted, size: 14),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ─── ERROR SCREEN ───────────────────────────
  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.fake, size: 64),
            const SizedBox(height: 16),
            Text(_lang == AppLanguage.urdu ? 'خرابی پیش آئی' : 'Something went wrong',
                style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(_lang == AppLanguage.urdu
                ? 'براہ کرم دوبارہ کوشش کریں'
                : 'Please check your connection and try again.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.black),
              child: Text(_lang == AppLanguage.urdu ? 'دوبارہ کوشش' : 'Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HISTORY BOTTOM SHEET ──────────────────
  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(_lang == AppLanguage.urdu ? 'حالیہ اسکین' : 'Scan History',
                    style: AppTextStyles.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(_lang == AppLanguage.urdu ? 'بند کریں' : 'Close',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(3, (i) {
              final levels = [CredibilityLevel.fake, CredibilityLevel.verified, CredibilityLevel.doubtful];
              final titles = [
                'COVID vaccine suppression claim',
                'State Bank interest rate hike',
                'Metro rail expansion 2026',
              ];
              final level = levels[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  Icon(_credIcon(level), color: _credColor(level), size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titles[i], style: AppTextStyles.bodyLarge.copyWith(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('${i + 1} ${_lang == AppLanguage.urdu ? "دن پہلے" : "day(s) ago"}',
                          style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
                    ],
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _credColor(level).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_credLabel(level),
                        style: AppTextStyles.mono.copyWith(fontSize: 9, color: _credColor(level))),
                  ),
                ]),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CUSTOM PAINTERS
// ─────────────────────────────────────────────
class _BracketPainter extends CustomPainter {
  final bool left;
  final bool top;
  final double thick;
  const _BracketPainter({required this.left, required this.top, required this.thick});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final x0 = left  ? 0.0 : size.width;
    final y0 = top   ? 0.0 : size.height;
    final x1 = left  ? size.width : 0.0;
    final y1 = top   ? size.height : 0.0;
    final path = Path()
      ..moveTo(x1, y0)
      ..lineTo(x0, y0)
      ..lineTo(x0, y1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}