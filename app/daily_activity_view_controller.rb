class DailyActivityViewController < UIViewController
  # include Teacup::TableViewDelegate
  stylesheet :main


  def viewDidLoad
    super

    self.title = "Today"

    self.view = UITableView.alloc.initWithFrame(App.frame, style:UITableViewStyleGrouped)
    self.view.delegate = self
    self.view.dataSource = self
    self.view.stylename = :activity_table_view

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
      cell = dailyActivityCell

      # Add relevant data
    elsif indexPath.section == NEW_ACTIVITY_SECTION_INDEX
      if indexPath.row == tableView(self.view, numberOfRowsInSection:indexPath.section) - 1 # If last row
        cell = newActivityFormCell
      else
        cell = newActivityCell

        # Add relevant data
      end
    end

    cell
  end

  ACTIVITY_EXERCISE_NAME_TAG = 1000
  SET_INFO_TAG = 1001
  def dailyActivityCell
    identifier = :daily_activity
    if cell = self.view.dequeueReusableCellWithIdentifier(identifier)
      cell
    else
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)

      layout cell.contentView do
        subview(UILabel, :activity_exercise_name, tag: ACTIVITY_EXERCISE_NAME_TAG)
        subview(UILabel, :set_info, tag: SET_INFO_TAG)
      end
    end

    exerciseName = cell.contentView.viewWithTag(ACTIVITY_EXERCISE_NAME_TAG)
    exerciseName.text = "Exercise!! #{rand(999)}"

    setInfo = cell.contentView.viewWithTag(SET_INFO_TAG)
    setInfo.text = "Sup, these are the sets #{rand(100)}"

    cell
  end

  NEW_ACTIVITY_INPUT_TAG = 1002
  def newActivityCell
    identifier = :new_activity_cell
    if cell = self.view.dequeueReusableCellWithIdentifier(identifier)
      cell
    else
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)

      layout cell.contentView do
        subview(UILabel, :new_activity_exercise_name, tag: ACTIVITY_EXERCISE_NAME_TAG)
      end
    end

    exerciseName = cell.contentView.viewWithTag(ACTIVITY_EXERCISE_NAME_TAG)
    exerciseName.text = "Exercise -- #{rand(999)}"

    cell
  end

  def newActivityFormCell
    identifier = :new_activity_form_cell
    if cell = self.view.dequeueReusableCellWithIdentifier(identifier)
      cell
    else
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)

      layout cell.contentView do
        subview(UITextField, :new_activity_input, tag: NEW_ACTIVITY_INPUT_TAG)
      end
    end

    #newActivityInput = cell.contentView.viewWithTag(NEW_ACTIVITY_INPUT_TAG)

    cell
  end
end
