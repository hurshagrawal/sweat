class DailyActivityViewController < UIViewController

  def viewDidLoad
    super

    self.title = "Today"

    self.view = UITableView.alloc.initWithFrame(App.frame, style:UITableViewStyleGrouped)
    self.view.delegate = self
    self.view.dataSource = self
    self.view.reloadData
  end


  ## UITableViewDataSource
  DAILY_ACTIVITY_SECTION_INDEX = 0
  NEW_ACTIVITY_SECTION_INDEX = 1

  def numberOfSectionsInTableView(tableView)
    2
  end

  def tableView(tableView, numberOfRowsInSection:section)
    3
  end

  def tableView(tableView, titleForHeaderInSection:section)
    ["Exercises", "Add Exercise"][section]
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    identifier = case indexPath.section
       when DAILY_ACTIVITY_SECTION_INDEX
         :daily_activity
       when NEW_ACTIVITY_SECTION_INDEX
         :new_activity
     end

    if cell = tableView.dequeueReusableCellWithIdentifier(identifier)
      cell
    else
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)
    end
  end
end
