class AppDelegate
  include MotionDataWrapper::Delegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    exerciseViewController = DailyExercisesViewController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(exerciseViewController)
    @window.rootViewController = navigationController

    @window.makeKeyAndVisible

    true
  end
end
