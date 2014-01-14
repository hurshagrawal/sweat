class AppDelegate
  include MotionDataWrapper::Delegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    activityViewController = DailyActivityViewController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(activityViewController)
    @window.rootViewController = navigationController

    @window.makeKeyAndVisible

    true
  end
end
