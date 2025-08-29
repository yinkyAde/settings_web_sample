import 'package:flutter/material.dart';

void main() => runApp(const SettingsSpecApp());

/* ===================== DESIGN TOKENS ===================== */
class T {

  static const bgPage = Color(0xFF0F1220);
  static const bgCard = Color(0xFF1A1F2E);
  static const bgSidebar = Color(0xFF14182A);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB6B9C5);
  static const dividers = Color(0x1FFFFFFF);
  static const border = Color(0x1AFFFFFF);
  static const white08 = Color(0x14FFFFFF);
  static const white10 = Color(0x1AFFFFFF);


  static const primary = Color(0xFF5B7CFA);


  static const gradBlueA = Color(0xFF3B82F6);
  static const gradBlueB = Color(0xFF2563EB);


  static const sbBlue = Color(0xFF3B82F6);
  static const sbTeal = Color(0xFF22D3EE);
  static const sbGreen = Color(0xFF22C55E);
  static const sbPurple = Color(0xFF8B5CF6);
  static const sbOrange = Color(0xFFF59E0B);

  // Radii
  static const rCard = 20.0;
  static const rTile = 14.0;
  static const rField = 14.0;
  static const rBadge = 12.0;
  static const rButton = 18.0;

  // Spacing
  static const page = 24.0;
  static const gap = 24.0;
  static const v = 18.0;

  // Breakpoints
  static const bpThree = 1200.0;
  static const bpSidebar = 880.0;
}

/* ===================== APP SHELL ===================== */
class SettingsSpecApp extends StatelessWidget {
  const SettingsSpecApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: T.primary, brightness: Brightness.dark),
      scaffoldBackgroundColor: T.bgPage,
      cardTheme: const CardThemeData(
        color: T.bgCard,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(T.rCard))),
      ),
      dividerColor: T.dividers,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: T.bgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T.rField),
          borderSide: const BorderSide(color: T.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T.rField),
          borderSide: const BorderSide(color: T.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(T.rField),
          borderSide: const BorderSide(color: T.primary),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: T.dividers),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        checkColor: MaterialStateProperty.all<Color>(Colors.white),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return T.primary;
          return T.white10;
        }),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Settings Spec',
      themeMode: ThemeMode.dark,
      theme: theme,
      home: const _Root(),
    );
  }
}

/* ===================== ROOT LAYOUT ===================== */
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final showThree = w >= T.bpThree;
      final showSidebar = w >= T.bpSidebar;

      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (showSidebar) const _Sidebar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(T.page),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Flexible(flex: 10, child: _SettingsColumn()),
                      const SizedBox(width: T.gap),
                      if (showThree)
                        const Flexible(flex: 14, child: _AccountSettingsPanel()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: showThree
            ? null
            : Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () => _showAccountSheet(context),
            icon: const Icon(Icons.manage_accounts_rounded),
            label: const Text('Account Settings'),
          ),
        ),
      );
    });
  }

  void _showAccountSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: T.bgPage,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .9,
        minChildSize: .5,
        maxChildSize: .95,
        builder: (ctx, controller) => const Padding(
          padding: EdgeInsets.all(T.page),
          child: _AccountSettingsPanel(),
        ),
      ),
    );
  }
}

/* ===================== COLUMN B ===================== */
class _SettingsColumn extends StatelessWidget {
  const _SettingsColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        SizedBox(height: T.v),
        _ProfileCardBlue(progress: .75),
        SizedBox(height: T.v),
        _SettingsList(),
      ],
    );
  }
}

/* ===================== SIDEBAR ===================== */
class _Sidebar extends StatelessWidget {
  const _Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: T.bgSidebar,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SidebarHeader(),
          _SidebarSection(
            title: 'Menu',
            items: [
              _NavItem('Dashboard', Icons.dashboard_rounded, T.sbBlue),
              _NavItem('Send Money', Icons.send_rounded, T.sbTeal),
              _NavItem('Top up Wallet', Icons.account_balance_wallet_rounded, T.sbGreen),
              _NavItem('Withdraw', Icons.download_rounded, T.sbBlue),
              _NavItem('Bill Payment', Icons.receipt_long_rounded, T.sbOrange),
              _NavItem('Settings', Icons.tune_rounded, T.sbPurple, selected: true),
            ],
          ),
          _SidebarSection(
            title: 'Other Menu',
            items: [
              _NavItem('History Transactions', Icons.history_rounded, T.sbBlue),
              _NavItem('Request Payment', Icons.request_quote_rounded, T.sbGreen),
              _NavItem('Help', Icons.help_outline_rounded, T.sbPurple),
            ],
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text('v1.0.0', style: TextStyle(color: Colors.white24)),
          ),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=5'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Samantha', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text('sam@email.com', style: TextStyle(color: T.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.settings, color: T.primary),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final Color badgeColor;
  final bool selected;
  const _NavItem(this.label, this.icon, this.badgeColor, {this.selected = false});
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final List<_NavItem> items;
  const _SidebarSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
            child: Text(title, style: const TextStyle(color: T.textSecondary, fontSize: 12, letterSpacing: .4)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  for (final it in items) _SidebarTile(item: it),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatefulWidget {
  final _NavItem item;
  const _SidebarTile({super.key, required this.item});

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.item.selected;


    Color bg = Colors.transparent;
    if (_hover && !selected) bg = T.white08;
    if (selected) bg = T.primary.withOpacity(.12);


    final labelColor = selected ? T.primary : Colors.white70;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
          color: bg,
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: widget.item.badgeColor.withOpacity(.22),
                  borderRadius: BorderRadius.circular(T.rBadge),
                ),
                child: Icon(widget.item.icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(widget.item.label, style: TextStyle(color: labelColor))),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===================== PROFILE CARD (BLUE GRADIENT) ===================== */
class _ProfileCardBlue extends StatelessWidget {
  final double progress;
  const _ProfileCardBlue({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [T.gradBlueA, T.gradBlueB],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(T.rCard),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
                    backgroundColor: Color(0x33FFFFFF),
                  ),
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  Center(
                    child: Text('${(progress * 100).round()}%',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile Informations',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  SizedBox(height: 6),
                  Text('Complete your profile to unlock all features',
                      style: TextStyle(color: Color(0xE6FFFFFF))),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: T.gradBlueB,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.rButton)),
              ),
              child: const Text('Complete My Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== SETTINGS LIST (CENTER CARD) ===================== */
class _SettingsList extends StatelessWidget {
  const _SettingsList();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _SettingTileData(Icons.dark_mode_rounded, 'Appearences', 'Dark and Light Mode, Font size'),
      _SettingTileData(Icons.person_rounded, 'Account Settings', 'Personal Informations, Email'),
      _SettingTileData(Icons.lock_rounded, 'Security', 'Change Password, 2FA'),
      _SettingTileData(Icons.dark_mode_outlined, 'Appearences', 'Dark and Light Mode, Font size'),
      _SettingTileData(Icons.person_outline_rounded, 'Account Settings', 'Personal Informations, Email'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final t in items) ...[
              _HoverRow(
                child: ListTile(
                  leading: Icon(t.icon, color: Theme.of(context).colorScheme.primary),
                  title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(t.subtitle, style: const TextStyle(color: T.textSecondary)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              if (t != items.last) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingTileData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SettingTileData(this.icon, this.title, this.subtitle);
}

class _HoverRow extends StatefulWidget {
  final Widget child;
  const _HoverRow({super.key, required this.child});
  @override
  State<_HoverRow> createState() => _HoverRowState();
}

class _HoverRowState extends State<_HoverRow> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: _hover ? T.white08 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.child,
      ),
    );
  }
}

/* ===================== ACCOUNT SETTINGS (RIGHT PANEL) ===================== */
class _AccountSettingsPanel extends StatefulWidget {
  const _AccountSettingsPanel({super.key});
  @override
  State<_AccountSettingsPanel> createState() => _AccountSettingsPanelState();
}

class _AccountSettingsPanelState extends State<_AccountSettingsPanel> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController(text: 'Samantha');
  final _last = TextEditingController(text: 'William');
  final _email = TextEditingController(text: 'sam@email.com');


  bool cbWithdraw = true;
  bool cbWeekly = true;
  bool cbPaymentSuccess = false;
  bool cbPasswordChange = false;
  bool cbTopUp = false;
  bool cbSendMoney = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Settings', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Personal Informations', style: TextStyle(color: T.textSecondary)),
            const SizedBox(height: T.v),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _LabeledField(label: 'First Name', controller: _first)),
                      const SizedBox(width: 14),
                      Expanded(child: _LabeledField(label: 'Last Name', controller: _last)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _EmailField(controller: _email),
                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Notifications', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 24,
                    runSpacing: 4,
                    children: [
                      _Check(label: 'Withdraw Activity', value: cbWithdraw, onChanged: (v) => setState(() => cbWithdraw = v)),
                      _Check(label: 'Weekly Report', value: cbWeekly, onChanged: (v) => setState(() => cbWeekly = v)),
                      _Check(label: 'Payment Success', value: cbPaymentSuccess, onChanged: (v) => setState(() => cbPaymentSuccess = v)),
                      _Check(label: 'Password Change', value: cbPasswordChange, onChanged: (v) => setState(() => cbPasswordChange = v)),
                      _Check(label: 'Top Up Success', value: cbTopUp, onChanged: (v) => setState(() => cbTopUp = v)),
                      _Check(label: 'Send Money Success', value: cbSendMoney, onChanged: (v) => setState(() => cbSendMoney = v)),
                    ],
                  ),

                  const SizedBox(height: 28),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          setState(() {});
                        },
                        child: const Text('Discard Changes'),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('Changes saved')));
                          }
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.rButton)),
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _LabeledField({required this.label, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: T.textSecondary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailField({required this.controller});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email Address', style: TextStyle(color: T.textSecondary)),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              controller: controller,
              validator: (v) {
                final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v ?? '');
                return ok ? null : 'Enter a valid email';
              },
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.verified_rounded, size: 16, color: cs.primary),
                const SizedBox(width: 6),
                Text('Email Verified',
                    style: TextStyle(color: cs.primary, fontSize: 12, fontWeight: FontWeight.w700)),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}

/* ===================== CHECKBOX (LABELED) ===================== */
class _Check extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Check({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
          const SizedBox(width: 6),
          Flexible(child: Text(label)),
        ],
      ),
    );
  }
}
