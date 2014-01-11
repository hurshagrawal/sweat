class DailyActivityViewController < UIViewController
  include Teacup::TableViewDelegate
  stylesheet :main

  DAILY_ACTIVITY_CELL_IDENTIFIER = :daily_activity_cell
  NEW_ACTIVITY_CELL_IDENTIFIER = :new_activity_cell
  NEW_ACTIVITY_FORM_CELL_IDENTIFIER = :new_activity_form_cell

  def viewDidLoad
    super

    self.title = "Today"

    self.view = UITableView.alloc.initWithFrame(App.frame, style:UITableViewStyleGrouped)
    self.view.delegate = self
    self.view.dataSource = self
    self.view.stylename = :activity_table_view

    self.view.registerClass(DailyActivityTableViewCell, forCellReuseIdentifier:DAILY_ACTIVITY_CELL_IDENTIFIER)
    self.view.registerClass(NewActivityFormTableViewCell, forCellReuseIdentifier:NEW_ACTIVITY_FORM_CELL_IDENTIFIER)
    self.view.registerClass(NewActivityTableViewCell, forCellReuseIdentifier:NEW_ACTIVITY_CELL_IDENTIFIER)

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
      cell = tableView.dequeueReusableCellWithIdentifier(DAILY_ACTIVITY_CELL_IDENTIFIER)

      cell.exerciseName.text = "sup homiez"

      # Add relevant data
    elsif indexPath.section == NEW_ACTIVITY_SECTION_INDEX
      if indexPath.row == tableView(self.view, numberOfRowsInSection:indexPath.section) - 1 # If last row
        cell = tableView.dequeueReusableCellWithIdentifier(NEW_ACTIVITY_FORM_CELL_IDENTIFIER)
      else
        cell = tableView.dequeueReusableCellWithIdentifier(NEW_ACTIVITY_CELL_IDENTIFIER)

        # Add relevant data
      end
    end

    cell
  end

  ## Templating
  class DailyActivityTableViewCell < UITableViewCell
    include Teacup::Layout
    stylesheet :main
    attr_accessor :exerciseName, :setInfo

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super

      layout self.contentView do
        self.exerciseName = subview(UILabel, :activity_exercise_name)
        self.setInfo = subview(UILabel, :set_info)
      end

      #auto self..contentView do
        #vertical "|-[activity_exercise_name]-[set_info]-|"
        #horizontal "|-[activity_exercise_name]-|"
        #horizontal "|-[set_info]-|"
      #end

      self
    end
  end

  class NewActivityFormTableViewCell < UITableViewCell
    include Teacup::Layout
    stylesheet :main
    attr_accessor :newActivityInput

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super

      layout self.contentView do
        self.newActivityInput = subview(UITextField, :new_activity_input)
      end

      self
    end
  end

  class NewActivityTableViewCell < UITableViewCell
    include Teacup::Layout
    stylesheet :main
    attr_accessor :exerciseName

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super

      layout self.contentView do
        self.exerciseName = subview(UILabel, :new_activity_exercise_name)
      end

      self
    end
  end
end
