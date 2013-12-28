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
    if indexPath.section == DAILY_ACTIVITY_SECTION_INDEX
      cell = cellForClass(DailyActivityTableViewCell, identifier:"daily_activity")

      # Add relevant data
    elsif indexPath.section == NEW_ACTIVITY_SECTION_INDEX
      if indexPath.row == tableView(self.view, numberOfRowsInSection:indexPath.section) - 1 # If last row
        cell = cellForClass(NewActivityFormTableViewCell, identifier:"new_activity_form")

      else
        cell = cellForClass(NewActivityTableViewCell, identifier:"new_activity")

        # Add relevant data
      end
    end

    cell
  end

  def cellForClass(cellClass, identifier:identifier)
    if cell = self.view.dequeueReusableCellWithIdentifier(identifier)
      cell
    else
      cellClass.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)
    end
  end

  ## Templating
  class NewActivityFormTableViewCell < UITableViewCell
    include Teacup::Layout

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super.tap do
        layout self.contentView do
          subview UILabel,
            text: "New Activity form yo",
            top: 0, left: 0,
            width: 200, height: 30,
            textColor: UIColor.greenColor
        end
      end
    end
  end

  class NewActivityTableViewCell < UITableViewCell
    include Teacup::Layout

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super.tap do
        layout self.contentView do
          subview UILabel,
            text: "this is new activity",
            top: 0, left: 0,
            width: 200, height: 30,
            backgroundColor: UIColor.blueColor
        end
      end
    end
  end

  class DailyActivityTableViewCell < UITableViewCell
    include Teacup::Layout

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super.tap do
        layout self.contentView do
          subview UILabel,
            text: "Sup label here",
            top: 0, left: 0,
            width: 200, height: 30,
            backgroundColor: UIColor.blackColor
        end
      end
    end
  end
end
