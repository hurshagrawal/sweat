class SetsViewController < UIViewController
  include Teacup::TableViewDelegate
  attr_accessor :exercise
  stylesheet :main

  def viewDidLoad
    super

    self.view = TPKeyboardAvoidingTableView.alloc.initWithFrame(App.frame, style:UITableViewStyleGrouped)

    self.view.delegate = self
    self.view.dataSource = self
    self.view.stylename = :activity_table_view

    self.view.registerClass(DailyActivityTableViewCell, forCellReuseIdentifier:DAILY_ACTIVITY_CELL_IDENTIFIER)
    self.view.registerClass(NewActivityFormTableViewCell, forCellReuseIdentifier:NEW_ACTIVITY_FORM_CELL_IDENTIFIER)
    self.view.registerClass(NewActivityTableViewCell, forCellReuseIdentifier:NEW_ACTIVITY_CELL_IDENTIFIER)

    setupNavigation
  end
end
