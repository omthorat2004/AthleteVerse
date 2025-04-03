import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
// Mobile-specific webview packages
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class YoYoTestScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  const YoYoTestScreen({super.key, required this.cameras});

  @override
  State<YoYoTestScreen> createState() => _YoYoTestScreenState();
}

class _YoYoTestScreenState extends State<YoYoTestScreen> with SingleTickerProviderStateMixin {
  // Camera/webview state
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _hasCameraError = false;
  late WebViewController _webViewController;
  bool _webViewInitialized = false;

  // Test state
  int _currentSection = 0;
  bool _isVerifying = false;
  double _verificationProgress = 0.0;
  late AnimationController _verificationController;
  late Animation<double> _verificationAnimation;
  bool _isRecording = false;
  int _currentLevel = 1;
  int _currentShuttle = 1;
  int _totalDistance = 0;

  // Test data
  List<TestResult> _testResults = [];
  final List<VerificationStep> _verificationSteps = [
    VerificationStep('Face Recognition', Icons.face, false),
    VerificationStep('GPS & Motion', Icons.gps_fixed, false),
    VerificationStep('Environment', Icons.wb_sunny, false),
    VerificationStep('Audio Check', Icons.mic, false),
  ];

  // Performance metrics
  final List<PerformanceMetric> _performanceMetrics = [
    PerformanceMetric('Speed', 85, 7),
    PerformanceMetric('Endurance', 92, 12),
    PerformanceMetric('Recovery', 75, 7),
    PerformanceMetric('Consistency', 88, 13),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeCamera();
    _verificationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _verificationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _verificationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _initializeData() {
    _testResults = [
      TestResult(
        DateTime.now().subtract(const Duration(days: 60)),
        12.0,
        1200,
        15.2,
        [
          ShuttleData(1, 8.0),
          ShuttleData(2, 8.5),
          ShuttleData(3, 9.0),
        ],
      ),
      TestResult(
        DateTime.now().subtract(const Duration(days: 30)),
        13.5,
        1450,
        16.0,
        [
          ShuttleData(1, 8.2),
          ShuttleData(2, 8.7),
          ShuttleData(3, 9.2),
        ],
      ),
      TestResult(
        DateTime.now(),
        14.2,
        1620,
        16.5,
        [
          ShuttleData(1, 8.5),
          ShuttleData(2, 9.0),
          ShuttleData(3, 9.5),
        ],
      ),
    ];
  }

  Future<void> _initializeCamera() async {
    if (kIsWeb) {
      await _initializeWebCamera();
      return;
    }

    try {
      if (widget.cameras.isEmpty) {
        setState(() => _hasCameraError = true);
        return;
      }

      _cameraController = CameraController(
        widget.cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => widget.cameras.first,
        ),
        ResolutionPreset.medium,
      );

      await _cameraController.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint('Camera error: $e');
      setState(() => _hasCameraError = true);
    }
  }

  Future<void> _initializeWebCamera() async {
    late final PlatformWebViewControllerCreationParams params;
    
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
        .setMediaPlaybackRequiresUserGesture(false);
    }

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController = controller;
    setState(() => _webViewInitialized = true);
  }

  Widget _buildCameraPreview() {
    if (kIsWeb) {
      if (!_webViewInitialized) {
        return const Center(child: CircularProgressIndicator());
      }
      return WebViewWidget(
        controller: _webViewController..loadHtmlString(_getWebCameraHTML()),
      );
    }

    if (_hasCameraError) {
      return _buildCameraError();
    }

    if (!_isCameraInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return CameraPreview(_cameraController);
  }

String _getWebCameraHTML() {
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Yo-Yo Test Camera</title>
  <style>
    body { 
      margin: 0; 
      padding: 0; 
      overflow: hidden;
      background-color: #000;
    }
    #videoContainer { 
      position: relative;
      width: 100%;
      height: 100%;
    }
    #video { 
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    #overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 16px;
      box-sizing: border-box;
      color: white;
      text-shadow: 1px 1px 3px rgba(0,0,0,0.8);
    }
    .test-info {
      background: rgba(0,0,0,0.5);
      padding: 8px 16px;
      border-radius: 20px;
      text-align: center;
    }
    #permissionMessage {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: white;
      background: rgba(0,0,0,0.7);
      padding: 20px;
      border-radius: 10px;
      text-align: center;
      max-width: 80%;
    }
    #permissionButton {
      margin-top: 15px;
      padding: 10px 20px;
      background: #4285F4;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div id="videoContainer">
    <video id="video" autoplay playsinline></video>
    <div id="overlay">
      <div class="test-info" id="levelInfo">Level: 1</div>
      <div class="test-info" id="shuttleInfo">Shuttle: 1/8</div>
      <div class="test-info" id="distanceInfo">Distance: 0m</div>
    </div>
    <div id="permissionMessage" style="display: none;">
      <p>Camera access is required for the Yo-Yo test.</p>
      <button id="permissionButton">Allow Camera Access</button>
    </div>
  </div>
  <script>
    const video = document.getElementById('video');
    const levelInfo = document.getElementById('levelInfo');
    const shuttleInfo = document.getElementById('shuttleInfo');
    const distanceInfo = document.getElementById('distanceInfo');
    const permissionMessage = document.getElementById('permissionMessage');
    const permissionButton = document.getElementById('permissionButton');
    
    // Check for camera support
    function hasGetUserMedia() {
      return !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
    }
    
    // Show appropriate message based on support
    if (!hasGetUserMedia()) {
      permissionMessage.innerHTML = '<p>Your browser does not support camera access or you may need to enable it in settings.</p>';
      permissionMessage.style.display = 'block';
      permissionButton.style.display = 'none';
    }
    
    // Request camera access
    async function startCamera() {
      try {
        permissionMessage.style.display = 'none';
        
        const stream = await navigator.mediaDevices.getUserMedia({ 
          video: { 
            facingMode: 'environment',
            width: { ideal: 1280 },
            height: { ideal: 720 }
          } 
        });
        
        video.srcObject = stream;
        return true;
      } catch (err) {
        console.error('Camera error:', err);
        
        // Show permission message with specific error
        let errorMessage = 'Could not access the camera.';
        if (err.name === 'NotAllowedError') {
          errorMessage = 'Camera access was denied. Please allow camera access to continue.';
        } else if (err.name === 'NotFoundError') {
          errorMessage = 'No camera found on this device.';
        } else if (err.name === 'NotReadableError') {
          errorMessage = 'Camera is already in use by another application.';
        }
        
       
        if (err.name !== 'NotFoundError') {
          permissionButton.style.display = 'block';
        } else {
          permissionButton.style.display = 'none';
        }
        permissionMessage.style.display = 'block';
        
        return false;
      }
    }
    
    // Update test info
    function updateTestInfo(level, shuttle, distance) {
      levelInfo.textContent = `Level: \${level}`;
      shuttleInfo.textContent = `Shuttle: \${shuttle}/8`;
      distanceInfo.textContent = `Distance: \${distance}m`;
    }
    
    // Initialize when page loads
    document.addEventListener('DOMContentLoaded', async () => {
      // Try to start camera automatically
      const success = await startCamera();
      
      if (success) {
        // Notify Flutter that webview is ready
        if (window.flutter_inappwebview) {
          window.flutter_inappwebview.callHandler('webViewReady');
        }
      }
    });
    
    // Retry button handler
    permissionButton.addEventListener('click', async () => {
      const success = await startCamera();
      if (success) {
        permissionMessage.style.display = 'none';
      }
    });
  </script>
</body>
</html>
''';
}

  Widget _buildCameraError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_off, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Camera not available'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _initializeCamera,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _startVerification() async {
    if (kIsWeb) {
      setState(() => _isVerifying = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isVerifying = false);
      return;
    }

    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    setState(() {
      _isVerifying = true;
      _verificationProgress = 0.0;
      for (var step in _verificationSteps) {
        step.isCompleted = false;
      }
    });

    _verificationController.reset();
    _verificationController.forward();

    for (int i = 0; i < _verificationSteps.length; i++) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _verificationSteps[i].isCompleted = true;
        _verificationProgress = (i + 1) / _verificationSteps.length;
      });
    }

    setState(() => _isVerifying = false);
  }

  void _startTest() {
    setState(() {
      _currentLevel = 1;
      _currentShuttle = 1;
      _totalDistance = 0;
      _isRecording = true;
    });
    
    if (kIsWeb) {
      _updateWebTestInfo();
    }
    
    _startTestTimer();
  }

  void _updateWebTestInfo() {
    _webViewController.runJavaScript(
      'updateTestInfo($_currentLevel, $_currentShuttle, $_totalDistance)'
    );
  }

  void _startTestTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRecording) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _totalDistance += 10;
        _currentShuttle++;
        
        if (_currentShuttle > 8) {
          _currentLevel++;
          _currentShuttle = 1;
        }
        
        if (kIsWeb) {
          _updateWebTestInfo();
        }
      });
    });
  }

  @override
  void dispose() {
    _verificationController.dispose();
    if (!kIsWeb && _isCameraInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yo-Yo Test'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildSectionButtons(),
            Expanded(
              child: IndexedStack(
                index: _currentSection,
                children: [
                  _buildDashboardSection(),
                  _buildTakeTestSection(),
                  _buildResultsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSectionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSectionButton('Dashboard', Icons.dashboard, 0),
            _buildSectionButton('Take Test', Icons.play_circle_fill, 1),
            _buildSectionButton('Results', Icons.analytics, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionButton(String title, IconData icon, int sectionIndex) {
    final isSelected = _currentSection == sectionIndex;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentSection = sectionIndex),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.blueAccent),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blueAccent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardSection() {
    final latestResult = _testResults.last;
    final nextLevelProgress = (latestResult.level - 12) / 6; // Levels 12-18

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Performance Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        color: Colors.blueAccent,
                        onPressed: _refreshData,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricTile(Icons.stacked_line_chart, 'Level', latestResult.level.toStringAsFixed(1)),
                      _buildMetricTile(Icons.directions_run, 'Distance', '${latestResult.distance}m'),
                      _buildMetricTile(Icons.speed, 'Max Speed', '${latestResult.maxSpeed} km/h'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: nextLevelProgress,
                    backgroundColor: Colors.blue.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(nextLevelProgress * 100).toStringAsFixed(0)}% to next level',
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildActionButton(Icons.play_arrow, 'Start Test', Colors.blueAccent, _startTest),
              _buildActionButton(Icons.history, 'History', Colors.blueGrey, _showHistory),
              _buildActionButton(Icons.insights, 'Trends', Colors.lightBlue, _showTrends),
              _buildActionButton(Icons.emoji_events, 'Achievements', Colors.amber, _showAchievements),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      primaryXAxis: CategoryAxis(
                        labelRotation: -45,
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 10,
                        maximum: 20,
                        interval: 2,
                        majorGridLines: const MajorGridLines(width: 1, color: Color(0xFFE0E0E0)),
                      ),
                      series: <CartesianSeries<TestResult, String>>[
                        LineSeries<TestResult, String>(
                          dataSource: _testResults,
                          xValueMapper: (TestResult result, _) => 
                            DateFormat('MMM dd').format(result.date),
                          yValueMapper: (TestResult result, _) => result.level,
                          markerSettings: const MarkerSettings(isVisible: true),
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakeTestSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (!_isRecording) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Test Setup',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete verification before starting the test',
              style: TextStyle(color: Colors.blueGrey),
            ),
            const SizedBox(height: 20),
            Column(
              children: _verificationSteps.map(_buildVerificationStep).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueAccent, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildCameraPreview(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Verification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _startVerification,
              ),
            ),
          ] else ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Test in Progress',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Current Level',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_currentLevel',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Shuttle $_currentShuttle/8',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Total Distance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_totalDistance m',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.stop),
                    label: const Text('End Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => setState(() => _isRecording = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    final latestResult = _testResults.last;
    final previousResult = _testResults.length > 1 ? _testResults[_testResults.length - 2] : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Test Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    color: Colors.blueAccent,
                    onPressed: _shareResults,
                  ),
                  IconButton(
                    icon: const Icon(Icons.download),
                    color: Colors.blueAccent,
                    onPressed: _exportResults,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildSummaryCard(Icons.stacked_line_chart, 'Level', latestResult.level.toStringAsFixed(1), _getLevelTitle(latestResult.level)),
              _buildSummaryCard(Icons.directions_run, 'Distance', '${latestResult.distance}m', 'Total'),
              _buildSummaryCard(Icons.speed, 'Max Speed', '${latestResult.maxSpeed} km/h', 'Peak'),
              _buildSummaryCard(
                Icons.trending_up, 
                'Improvement', 
                previousResult != null 
                  ? '+${(latestResult.level - previousResult.level).toStringAsFixed(1)}' 
                  : 'N/A', 
                'vs previous'
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shuttle Performance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: 'Shuttle Number'),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Speed (km/h)'),
                      ),
                      series: <CartesianSeries>[
                        ColumnSeries<ShuttleData, int>(
                          dataSource: latestResult.shuttleData,
                          xValueMapper: (ShuttleData data, _) => data.shuttleNumber,
                          yValueMapper: (ShuttleData data, _) => data.speed,
                          color: Colors.blueAccent,
                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: _performanceMetrics.map(_buildPerformanceMetric).toList(),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Training Recommendations',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            Icons.directions_run,
            'Endurance Training',
            'Focus on maintaining consistent pace through all shuttles',
          ),
          _buildRecommendationCard(
            Icons.bolt,
            'Speed Development',
            'Improve your acceleration between turns',
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildMetricTile(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blueAccent),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationStep(VerificationStep step) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: step.isCompleted 
                ? Colors.green.withOpacity(0.2)
                : Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            step.icon,
            color: step.isCompleted ? Colors.green : Colors.blueAccent,
          ),
        ),
        title: Text(
          step.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: step.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : _isVerifying
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.pending, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildSummaryCard(IconData icon, String title, String value, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(PerformanceMetric metric) {
    final isPositive = metric.change >= 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metric.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${metric.value}%',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${isPositive ? '+' : ''}${metric.change}%',
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: metric.value / 100,
              backgroundColor: Colors.blue.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPositive ? Colors.blueAccent : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(IconData icon, String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blueAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  String _getLevelTitle(double level) {
    if (level >= 16) return 'Elite';
    if (level >= 14) return 'Advanced';
    if (level >= 12) return 'Intermediate';
    return 'Beginner';
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('App settings will appear here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing data...')),
    );
  }

  void _showHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Test History')),
          body: const Center(child: Text('Test history will appear here')),
        ),
      ),
    );
  }

  void _showTrends() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Performance Trends')),
          body: const Center(child: Text('Performance trends will appear here')),
        ),
      ),
    );
  }

  void _showAchievements() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Achievements')),
          body: const Center(child: Text('Your achievements will appear here')),
        ),
      ),
    );
  }

  void _shareResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing results...')),
    );
  }

  void _exportResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting results...')),
    );
  }
}
 class TestResult {
    final DateTime date;
    final double level;
    final int distance;
    final double maxSpeed;
    final List<ShuttleData> shuttleData;

    TestResult(this.date, this.level, this.distance, this.maxSpeed, this.shuttleData);
  }

  class ShuttleData {
    final int shuttleNumber;
    final double speed;

    ShuttleData(this.shuttleNumber, this.speed);
  }

  class VerificationStep {
    final String title;
    final IconData icon;
    bool isCompleted;

    VerificationStep(this.title, this.icon, this.isCompleted);
  }

  class PerformanceMetric {
    final String name;
    final int value;
    final int change;

    PerformanceMetric(this.name, this.value, this.change);
  }

