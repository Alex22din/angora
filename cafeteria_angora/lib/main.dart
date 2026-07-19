import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CafeteriaAngoraApp());
}

class CafeteriaAngoraApp extends StatelessWidget {
  const CafeteriaAngoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafeteria Angora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4A853),
          secondary: Color(0xFF00D4FF),
          surface: Color(0xFF111638),
        ),
        fontFamily: 'Inter',
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _catAnimCtrl;
  late final AnimationController _floatCtrl;
  late final AnimationController _sparkleCtrl;
  late final AnimationController _pulseCtrl;

  int _activeCat = 0;
  final List<_Particle> _particles = [];
  final List<_Sparkle> _sparkles = [];

  final _catKeys = {
    'gourmandises': GlobalKey(),
    'chaudes': GlobalKey(),
    'froides': GlobalKey(),
    'pizzas': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _catAnimCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _sparkleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);

    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: Random().nextDouble(),
        speed: 10 + Random().nextDouble() * 20,
        delay: Random().nextDouble() * 20,
        size: 1 + Random().nextDouble() * 2,
        isGold: Random().nextBool(),
      ));
    }
    for (int i = 0; i < 12; i++) {
      _sparkles.add(_Sparkle(
        x: Random().nextDouble(),
        y: Random().nextDouble(),
        delay: i * 0.3,
        size: 2 + Random().nextDouble() * 4,
      ));
    }
  }

  @override
  void dispose() {
    _catAnimCtrl.dispose();
    _floatCtrl.dispose();
    _sparkleCtrl.dispose();
    _pulseCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(int i) {
    setState(() => _activeCat = i);
    final keys = [_catKeys['gourmandises']!, _catKeys['chaudes']!, _catKeys['froides']!, _catKeys['pizzas']!];
    final ctx = keys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 500), alignment: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ..._buildParticles(),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: const Color(0xFFD4A853).withValues(alpha: 0.10)),
                  right: BorderSide(color: const Color(0xFFD4A853).withValues(alpha: 0.10)),
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: Column(children: [
                        const SizedBox(height: 16),
                        _header(),
                        const SizedBox(height: 32),
                        _navDots(),
                        const SizedBox(height: 8),
                        _section('🥞', 'GOURMANDISES', 'Douceurs & Délices', 6, _catKeys['gourmandises']!, [
                          _item('🥞', 'Crêpes Angora', 'Pâte légère à la vanille, miel & amandes', '600', badge: 'Signature'),
                          _item('🧇', 'Gaufres Royales', 'Gaufres dorées, chantilly & coulis', '550'),
                          _item('🥞', 'Pancakes Nuage', 'Empilement fluffy, sirop érable', '650', badge: 'Best-seller', blue: true),
                          _item('🍫', 'Crêpes Choco-Angora', 'Pâte au cacao, Nutella & noisettes', '700'),
                          _item('🍩', 'Waffle Brioche', 'Gaufre briochée, fleur d\'oranger, miel', '580'),
                          _item('🍨', 'Coupe Angora', 'Glace vanille, caramel beurre salé', '750', badge: 'Premium'),
                        ]),
                        const SizedBox(height: 30),
                        _section('☕', 'BOISSONS CHAUDES', 'Espresso & Traditions', 5, _catKeys['chaudes']!, [
                          _item('☕', 'Espresso Angora', 'Corsé & crémeux, cacao & noisette', '350', badge: 'Signature'),
                          _item('☕', 'Cappuccino Royal', 'Mousse de lait, cacao amer', '450'),
                          _item('🫖', 'Thé à la Menthe', 'Thé vert, menthe fraîche & sucre', '300'),
                          _item('🍵', 'Chocolat Viennois', 'Chocolat chaud, chantilly', '500', badge: 'Best-seller', blue: true),
                          _item('🫖', 'Thé Impérial', 'Thé noir, épices, orange & cannelle', '380'),
                        ]),
                        const SizedBox(height: 30),
                        _section('🥤', 'BOISSONS FROIDES', 'Fraîcheur & Créations', 6, _catKeys['froides']!, [
                          _item('🥤', 'Bleu Mojito', 'Mojito bleu, menthe & citron vert', '500', badge: 'Signature'),
                          _item('🥤', 'Milkshake Pistache', 'Purée de pistache, lait, éclats', '650'),
                          _item('🥤', 'Milkshake Nutella', 'Nutella, lait frappé, chantilly', '650', badge: 'Best-seller', blue: true),
                          _item('🍊', 'Jus d\'Orange Pressé', 'Orange pressée, pulpe & glace', '350'),
                          _item('🥤', 'Limonade Menthe', 'Citron, menthe, eau pétillante', '400'),
                          _item('🧋', 'Iced Latte Caramel', 'Café frappé, caramel salé', '550'),
                        ]),
                        const SizedBox(height: 30),
                        _section('🍕', 'PIZZAS & TACOS', 'Savoureux & Généreux', 6, _catKeys['pizzas']!, [
                          _item('🍕', 'Pizza MEGA Angora', 'Mozzarella, pepperoni, basilic', '2000', badge: 'Signature'),
                          _item('🍕', 'Pizza 4 Fromages', 'Gorgonzola, parmesan, chèvre', '1800'),
                          _item('🌮', 'Taco Poulet Croquant', 'Poulet croustillant, sauce blanche', '900', badge: 'Best-seller', blue: true),
                          _item('🌮', 'Taco Angora', 'Viande hachée épicée, sauce secrète', '1100'),
                          _item('🍕', 'Pizza Margherita', 'Tomate, mozzarella, basilic', '1500'),
                          _item('🌯', 'Taco Bœuf & Avocat', 'Bœuf grillé, guacamole, salsa', '1200', badge: 'Premium'),
                        ]),
                        const SizedBox(height: 20),
                        _footer(),
                        const SizedBox(height: 20),
                      ]),
                    ),
                    Positioned(
                      top: 155,
                      left: 0,
                      right: 0,
                      height: 120,
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: Listenable.merge([_catAnimCtrl, _floatCtrl]),
                          builder: (context, _) {
                            final h = _catAnimCtrl.value;
                            final w = MediaQuery.of(context).size.width - 60;
                            final v = sin(h * 2 * pi * 1.5) * 25;
                            final f = sin(_floatCtrl.value * 2 * pi) * 4;
                            final dir = h < 0.5 ? 1.0 : -1.0;
                            return Transform.translate(
                              offset: Offset(h * w - 50, v + f + 10),
                              child: _cat(dir),
                            );
                          },
                        ),
                      ),
                    ),
                    // sparkles
                    ...List.generate(_sparkles.length, (i) {
                      final s = _sparkles[i];
                      return AnimatedBuilder(
                        animation: _sparkleCtrl,
                        builder: (context, _) {
                          final phase = (_sparkleCtrl.value + s.delay) % 1.0;
                          final o = phase < 0.5 ? phase * 2 : (1 - phase) * 2;
                          return Positioned(
                            left: s.x * (MediaQuery.of(context).size.width - 40),
                            top: 155 + s.y * 40,
                            child: Container(
                              width: s.size, height: s.size,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0CF7A).withValues(alpha: o),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: const Color(0xFFD4A853).withValues(alpha: o * 0.5), blurRadius: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐱', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFFF0CF7A), Color(0xFFD4A853), Color(0xFFF0CF7A)],
            ).createShader(b),
            child: const Text('Cafeteria Angora',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: Colors.white)),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text('MENU DIGITAL • PREMIUM',
        style: TextStyle(fontSize: 11, letterSpacing: 4, color: Colors.white.withValues(alpha: 0.4), fontWeight: FontWeight.w300)),
      const SizedBox(height: 10),
      Container(
        width: 60, height: 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.transparent, Color(0xFFD4A853), Colors.transparent]),
        ),
      ),
    ]);
  }

  Widget _cat(double dir) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(dir, 1.0, 1.0),
      child: AnimatedBuilder(
        animation: _floatCtrl,
        builder: (context, _) {
          final fy = sin(_floatCtrl.value * 2 * pi) * 4;
          return Transform.translate(
            offset: Offset(0, fy),
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: const Color(0xFFD4A853).withValues(alpha: 0.25), blurRadius: 20, spreadRadius: 2)],
              ),
              child: CustomPaint(painter: _CatPainter(), size: const Size(90, 90)),
            ),
          );
        },
      ),
    );
  }

  Widget _navDots() {
    final cats = ['Gourmandises', 'Chaudes', 'Froides', 'Pizzas & Tacos'];
    final icons = ['🥞', '☕', '🥤', '🍕'];
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(4, (i) {
          final active = _activeCat == i;
          return AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (context, _) {
              final p = active ? sin(_pulseCtrl.value * 2 * pi) * 0.3 + 0.7 : 0.0;
              return GestureDetector(
                onTap: () => _scrollTo(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFD4A853).withValues(alpha: 0.12 + p * 0.08) : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: active
                          ? const Color(0xFFD4A853).withValues(alpha: 0.6 + p * 0.3)
                          : const Color(0xFFD4A853).withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(icons[i], style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(cats[i], style: TextStyle(
                      fontSize: 11, fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active ? const Color(0xFFF0CF7A) : Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 0.5,
                    )),
                  ]),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _section(String icon, String title, String sub, int count, GlobalKey key, List<Widget> items) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(colors: [Color(0xFFF0CF7A), Color(0xFFD4A853)]).createShader(b),
                child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 1, color: Colors.white)),
              ),
              Text(sub, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.35), letterSpacing: 2, fontWeight: FontWeight.w300)),
            ]),
            const Spacer(),
            Text(count.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.35), letterSpacing: 1)),
          ]),
        ),
        ...items,
      ],
    );
  }

  Widget _item(String emoji, String name, String desc, String price, {String? badge, bool blue = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111638).withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4A853).withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0E27),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4A853).withValues(alpha: 0.06)),
                ),
                child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFF0F0F0), letterSpacing: 0.3)),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.4), fontWeight: FontWeight.w300)),
                  const SizedBox(height: 5),
                  Row(children: [
                    Text('$price DA', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFF0CF7A), letterSpacing: 0.5)),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: (blue ? const Color(0xFF00D4FF) : const Color(0xFFD4A853)).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: (blue ? const Color(0xFF00D4FF) : const Color(0xFFD4A853)).withValues(alpha: 0.15)),
                        ),
                        child: Text(badge, style: TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w500,
                          color: blue ? const Color(0xFF00D4FF) : const Color(0xFFD4A853),
                          letterSpacing: 0.5,
                        )),
                      ),
                    ],
                  ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return Column(children: [
      Container(
        height: 1,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.transparent, Color(0xFFD4A853), Colors.transparent]),
        ),
      ),
      Text('Cafeteria Angora', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFD4A853), letterSpacing: 1)),
      const SizedBox(height: 2),
      Text('~ L\'élégance à chaque bouchée ~',
        style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.3), letterSpacing: 1, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
    ]);
  }

  List<Widget> _buildParticles() {
    return _particles.map((p) {
      return AnimatedBuilder(
        animation: _catAnimCtrl,
        builder: (context, _) {
          final t = (_catAnimCtrl.value * p.speed + p.delay) % 1.0;
          final y = t * MediaQuery.of(context).size.height;
          final o = t < 0.1 ? t * 10 : (t > 0.9 ? (1 - t) * 10 : 0.35);
          return Positioned(
            left: p.x * MediaQuery.of(context).size.width,
            top: y,
            child: Container(
              width: p.size, height: p.size,
              decoration: BoxDecoration(
                color: (p.isGold ? const Color(0xFFD4A853) : const Color(0xFF00D4FF)).withValues(alpha: o),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    }).toList();
  }
}

// ──────────── CAT PAINTER ────────────
class _CatPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;

    Paint shaderPaint(List<Color> colors, Rect rect) => Paint()
      ..shader = RadialGradient(colors: colors).createShader(rect);

    // Body
    c.drawOval(Rect.fromCenter(center: Offset(cx, cy + 10), width: 72, height: 50),
      shaderPaint([const Color(0xFFFFF8F0), const Color(0xFFFFFFFF), const Color(0xFFF0E6D6)],
        Rect.fromCircle(center: Offset(cx, cy + 10), radius: 40)));

    // Brioche stripe
    final bp = Paint()..color = const Color(0xFFC4953A).withValues(alpha: 0.5);
    final bPath = Path()
      ..moveTo(cx - 32, cy - 4)
      ..quadraticBezierTo(cx, cy - 22, cx + 32, cy - 4)
      ..quadraticBezierTo(cx + 32, cy + 8, cx, cy + 16)
      ..quadraticBezierTo(cx - 32, cy + 8, cx - 32, cy - 4)
      ..close();
    c.drawPath(bPath, bp);
    final dp = Paint()..color = const Color(0xFFD4A853).withValues(alpha: 0.35);
    for (int i = 0; i < 8; i++) {
      c.drawCircle(Offset(cx + (i - 4) * 7 + 2, cy - 1 + (i % 3) * 5), 1.8, dp);
    }
    final dd = Paint()..color = const Color(0xFFB8860B).withValues(alpha: 0.25);
    for (int i = 0; i < 6; i++) {
      c.drawCircle(Offset(cx + (i - 3) * 8, cy + 3 + (i % 2) * 4), 1.3, dd);
    }

    // Tail
    final tp = shaderPaint([const Color(0xFFFFF8F0), const Color(0xFFFFFFFF)],
      Rect.fromLTWH(cx + 28, cy - 18, 28, 35));
    final tPath = Path()
      ..moveTo(cx + 32, cy - 4)
      ..cubicTo(cx + 40, cy - 16, cx + 46, cy - 30, cx + 43, cy - 36)
      ..cubicTo(cx + 41, cy - 33, cx + 38, cy - 26, cx + 36, cy - 18)
      ..cubicTo(cx + 34, cy - 10, cx + 33, cy - 4, cx + 32, cy - 4);
    c.drawPath(tPath, tp);
    c.drawCircle(Offset(cx + 43, cy - 38), 4, tp);

    // Head
    c.drawOval(Rect.fromCenter(center: Offset(cx, cy - 18), width: 50, height: 44),
      shaderPaint([const Color(0xFFFFF8F0), const Color(0xFFFFFFFF), const Color(0xFFF0E6D6)],
        Rect.fromCircle(center: Offset(cx, cy - 18), radius: 28)));

    // Cheeks
    final ch = Paint()..color = const Color(0xFFFFF8F0).withValues(alpha: 0.5);
    c.drawOval(Rect.fromCenter(center: Offset(cx - 18, cy - 14), width: 20, height: 14), ch);
    c.drawOval(Rect.fromCenter(center: Offset(cx + 18, cy - 14), width: 20, height: 14), ch);

    // Ears
    Paint earP = shaderPaint([const Color(0xFFFFF8F0), const Color(0xFFFFFFFF)],
      Rect.fromLTWH(cx - 26, cy - 50, 20, 22));
    Path le = Path()..moveTo(cx - 18, cy - 34)..lineTo(cx - 26, cy - 52)..lineTo(cx - 7, cy - 40)..close();
    c.drawPath(le, earP);
    Path re = Path()..moveTo(cx + 18, cy - 34)..lineTo(cx + 26, cy - 52)..lineTo(cx + 7, cy - 40)..close();
    c.drawPath(re, earP);
    final ip = Paint()..color = const Color(0xFFF5D0D0).withValues(alpha: 0.5);
    c.drawPath(Path()..moveTo(cx - 17, cy - 36)..lineTo(cx - 23, cy - 50)..lineTo(cx - 10, cy - 40)..close(), ip);
    c.drawPath(Path()..moveTo(cx + 17, cy - 36)..lineTo(cx + 23, cy - 50)..lineTo(cx + 10, cy - 40)..close(), ip);

    // Blue eye
    final be = Paint()..shader = const RadialGradient(
      colors: [Color(0xFFA8E6FF), Color(0xFF00B4FF), Color(0xFF0055AA)],
    ).createShader(Rect.fromCenter(center: Offset(cx - 9, cy - 18), width: 14, height: 15));
    c.drawOval(Rect.fromCenter(center: Offset(cx - 9, cy - 18), width: 13, height: 14), be);
    Paint()..color = const Color(0xFFA8E6FF).withValues(alpha: 0.25)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Gold eye
    final ge = Paint()..shader = const RadialGradient(
      colors: [Color(0xFFFFE8A0), Color(0xFFD4A853), Color(0xFFB8860B)],
    ).createShader(Rect.fromCenter(center: Offset(cx + 9, cy - 18), width: 14, height: 15));
    c.drawOval(Rect.fromCenter(center: Offset(cx + 9, cy - 18), width: 13, height: 14), ge);

    // Glows
    final bg = Paint()..color = const Color(0xFFA8E6FF).withValues(alpha: 0.25)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    c.drawOval(Rect.fromCenter(center: Offset(cx - 9, cy - 18), width: 17, height: 18), bg);
    final gg = Paint()..color = const Color(0xFFFFE8A0).withValues(alpha: 0.25)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    c.drawOval(Rect.fromCenter(center: Offset(cx + 9, cy - 18), width: 17, height: 18), gg);

    // Highlights
    final hw = Paint()..color = Colors.white.withValues(alpha: 0.8);
    c.drawOval(Rect.fromCenter(center: Offset(cx - 11, cy - 20), width: 4, height: 5), hw);
    c.drawOval(Rect.fromCenter(center: Offset(cx + 7, cy - 20), width: 4, height: 5), hw);
    final th = Paint()..color = Colors.white.withValues(alpha: 0.9);
    c.drawCircle(Offset(cx - 9, cy - 22), 1.5, th);
    c.drawCircle(Offset(cx + 9, cy - 22), 1.5, th);

    // Nose
    final np = Paint()..color = const Color(0xFFF5A0A0);
    c.drawPath(Path()..moveTo(cx - 2.5, cy - 6)..lineTo(cx, cy - 2.5)..lineTo(cx + 2.5, cy - 6)..close(), np);

    // Mouth
    final mp = Paint()..color = const Color(0xFFD4A853).withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 0.7;
    c.drawPath(Path()..moveTo(cx, cy - 2.5)..quadraticBezierTo(cx - 5, cy + 2, cx - 7, cy), mp);
    c.drawPath(Path()..moveTo(cx, cy - 2.5)..quadraticBezierTo(cx + 5, cy + 2, cx + 7, cy), mp);

    // Whiskers
    final wp = Paint()..color = const Color(0xFFE8DCC8).withValues(alpha: 0.4)..strokeWidth = 0.5;
    for (int side = -1; side <= 1; side += 2) {
      final ox = side * cx;
      for (int j = 0; j < 3; j++) {
        c.drawLine(Offset(cx + ox * 0.22, cy - 11 + j * 4), Offset(cx + ox * 0.38, cy - 14 + j * 5), wp);
      }
    }

    // Paws
    final pp = Paint()..color = const Color(0xFFFFF8F0);
    c.drawOval(Rect.fromCenter(center: Offset(cx - 14, cy + 30), width: 14, height: 9), pp);
    c.drawOval(Rect.fromCenter(center: Offset(cx + 14, cy + 30), width: 14, height: 9), pp);
    final pd = Paint()..color = const Color(0xFFF5D0D0).withValues(alpha: 0.35);
    c.drawCircle(Offset(cx - 14, cy + 30), 2.5, pd);
    c.drawCircle(Offset(cx + 14, cy + 30), 2.5, pd);

    // Fur lines
    final fl = Paint()..color = const Color(0xFFF0E6D6).withValues(alpha: 0.15)..strokeWidth = 0.4;
    for (int i = 0; i < 4; i++) {
      c.drawLine(Offset(cx - 16, cy + 2 + i * 5), Offset(cx + 16, cy + 2 + i * 5), fl);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Sparkle {
  final double x, y, delay, size;
  _Sparkle({required this.x, required this.y, required this.delay, required this.size});
}

class _Particle {
  final double x, speed, delay, size;
  final bool isGold;
  _Particle({required this.x, required this.speed, required this.delay, required this.size, required this.isGold});
}
