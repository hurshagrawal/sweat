class DailyActivityViewController < UIViewController
  include Teacup::TableViewDelegate
  stylesheet :main

  DAILY_ACTIVITY_CELL_IDENTIFIER = :daily_activity_cell
  NEW_ACTIVITY_CELL_IDENTIFIER = :new_activity_cell
  NEW_ACTIVITY_FORM_CELL_IDENTIFIER = :new_activity_form_cell

  def viewDidLoad
    super

    tableView = UITableView.alloc.initWithFrame(App.frame, style:UITableViewStyleGrouped)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.stylename = :activity_table_view

    tableView.registerClass(DailyActivityTableViewCell, forCellReuseIdentifier:DAILY_ACTIVITY_CELL_IDENTIFIER)
    tableView.registerClass(NewActivityFormTableViewCell, forCellReuseIdentifier:NEW_ACTIVITY_FORM_CELL_IDENTIFIER)
    tableView.registerClass(NewActivityTableViewCell, forCellReuseIdentifier:NEW_ACTIVITY_CELL_IDENTIFIER)

    self.view = tableView

    # Add back and forward buttons
    self.navigationItem.leftBarButtonItem = BW::UIBarButtonItem.styled(:plain, "Prev") do
      @currentDate = @currentDate.delta(days: -1)
      loadDate(@currentDate, forTableView:tableView, withRowAnimation:UITableViewRowAnimationRight)
    end

    self.navigationItem.rightBarButtonItem = BW::UIBarButtonItem.styled(:plain, "Next") do
      @currentDate = @currentDate.delta(days: 1)
      loadDate(@currentDate, forTableView:tableView, withRowAnimation:UITableViewRowAnimationLeft)
    end

    @currentDate = Time.now
    loadDate(@currentDate, forTableView:tableView, withRowAnimation:UITableViewRowAnimationNone)
  end

  def loadDate(date, forTableView:tableView, withRowAnimation:rowAnimation)
    if date > Time.now.start_of_day && date < Time.now.end_of_day
      self.title = "Today"
    else
      self.title = date.strftime("%b %d, %Y")
    end

    tableView.beginUpdates
    sections = NSIndexSet.indexSetWithIndex(DAILY_ACTIVITY_SECTION_INDEX)
    tableView.reloadSections(sections, withRowAnimation:rowAnimation)
    tableView.endUpdates
  end

  ## UITableViewDataSource
  DAILY_ACTIVITY_SECTION_INDEX = 0
  NEW_ACTIVITY_SECTION_INDEX = 1

  def numberOfSectionsInTableView(tableView)
    2
  end

  def tableView(tableView, numberOfRowsInSection:section)
    case section
    when DAILY_ACTIVITY_SECTION_INDEX
      Exercise.performedOnDay(@currentDate).count
    when NEW_ACTIVITY_SECTION_INDEX
      ExerciseType.count + 1
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    ["Exercises", "Add Exercise"][section]
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    case indexPath.section
    when DAILY_ACTIVITY_SECTION_INDEX
      cell = tableView.dequeueReusableCellWithIdentifier(DAILY_ACTIVITY_CELL_IDENTIFIER)

      exercise = Exercise.performedOnDay(@currentDate).offset(indexPath.row).limit(1).first

      cell.exerciseName.text = exercise.exerciseType.name
      cell.setInfo.text = "150x5 155x5 160x5 160x5 160x10"

    when NEW_ACTIVITY_SECTION_INDEX
      if indexPath.row == tableView(self.view, numberOfRowsInSection:indexPath.section) - 1 # If last row
        cell = tableView.dequeueReusableCellWithIdentifier(NEW_ACTIVITY_FORM_CELL_IDENTIFIER)
      else
        cell = tableView.dequeueReusableCellWithIdentifier(NEW_ACTIVITY_CELL_IDENTIFIER)

        exerciseType = ExerciseType.offset(indexPath.row).limit(1).first
        cell.exerciseName.text = exerciseType.name
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

      auto self.contentView do
        vertical "|[activity_exercise_name]-[set_info]|"
        horizontal "|-[activity_exercise_name]-|"
        horizontal "|-[set_info]-|"
      end

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
