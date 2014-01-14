class DailyExercisesViewController < UIViewController
  include Teacup::TableViewDelegate
  stylesheet :main

  EXERCISE_CELL_IDENTIFIER = :exercise_cell
  EXERCISE_TYPE_CELL_IDENTIFIER = :exercise_type_cell
  NEW_EXERCISE_TYPE_CELL_IDENTIFIER = :new_exercise_type_cell

  def viewDidLoad
    super

    self.view = TPKeyboardAvoidingTableView.alloc.initWithFrame(App.frame, style:UITableViewStyleGrouped)

    self.view.delegate = self
    self.view.dataSource = self
    self.view.stylename = :daily_exercise_table_view

    self.view.registerClass(ExerciseTableViewCell, forCellReuseIdentifier:EXERCISE_CELL_IDENTIFIER)
    self.view.registerClass(NewExerciseTypeTableViewCell, forCellReuseIdentifier:NEW_EXERCISE_TYPE_CELL_IDENTIFIER)
    self.view.registerClass(ExerciseTypeTableViewCell, forCellReuseIdentifier:EXERCISE_TYPE_CELL_IDENTIFIER)

    setupNavigation
  end

  def viewWillAppear(animated)
    reloadExerciseDataForTableView(self.view, withRowAnimation:UITableViewRowAnimationNone)
    reloadExerciseTypeDataForTableView(self.view)
  end

  def setupNavigation
    tableView = self.view

    # Add back and forward buttons
    self.navigationItem.leftBarButtonItem = BW::UIBarButtonItem.styled(:plain, "Prev") do
      @currentDate = @currentDate.delta(days: -1)
      updateTitle(@currentDate)
      reloadExerciseDataForTableView(tableView, withRowAnimation:UITableViewRowAnimationRight)
    end

    self.navigationItem.rightBarButtonItem = BW::UIBarButtonItem.styled(:plain, "Next") do
      @currentDate = @currentDate.delta(days: 1)
      updateTitle(@currentDate)
      reloadExerciseDataForTableView(tableView, withRowAnimation:UITableViewRowAnimationLeft)
    end

    @currentDate = Time.now
    updateTitle(@currentDate)
    reloadExerciseDataForTableView(tableView, withRowAnimation:UITableViewRowAnimationNone)
  end

  def updateTitle(date)
    if date > Time.now.start_of_day && date < Time.now.end_of_day
      self.title = "Today"
    else
      self.title = date.strftime("%b %d, %Y")
    end
  end

  def reloadExerciseDataForTableView(tableView, withRowAnimation:rowAnimation)
    tableView.beginUpdates
    @exercises = Exercise.performedOnDay(@currentDate).all
    sections = NSIndexSet.indexSetWithIndex(EXERCISE_SECTION_INDEX)
    tableView.reloadSections(sections, withRowAnimation:rowAnimation)
    tableView.endUpdates
  end

  def reloadExerciseTypeDataForTableView(tableView)
    tableView.beginUpdates
    @exerciseTypes = ExerciseType.all
    sections = NSIndexSet.indexSetWithIndex(EXERCISE_SECTION_INDEX)
    tableView.reloadSections(sections, withRowAnimation:UITableViewRowAnimationNone)
    tableView.endUpdates
  end

  def createExerciseTypeAndTransition(name)
    exerciseType = ExerciseType.where("name = ?", name).first || ExerciseType.create(name: name)

    createExerciseAndTransition(exerciseType)
  end

  def createExerciseAndTransition(exerciseType)
    exercise = Exercise.new(created_at: Time.now, performed_at: @currentDate)

    context = App.delegate.managedObjectContext
    context.insertObject(exercise)

    exercise.exerciseType = exerciseType
    exercise.save

    pushSetsViewController(exercise)
  end

  def pushSetsViewController(exercise)
    viewController = SetsViewController.alloc.init
    viewController.exercise = exercise

    navigationViewController = App.window.rootViewController
    navigationViewController.pushViewController(viewController, animated:true)
  end

  ## UITableViewDataSource / UITableViewDelegate ##

  EXERCISE_SECTION_INDEX = 0
  EXERCISE_TYPE_SECTION_INDEX = 1

  def numberOfSectionsInTableView(tableView)
    2
  end

  def tableView(tableView, numberOfRowsInSection:section)
    case section
    when EXERCISE_SECTION_INDEX
      @exercises.count
    when EXERCISE_TYPE_SECTION_INDEX
      ExerciseType.count + 1
    end
  end

  def tableView(tableView, titleForHeaderInSection:section)
    ["Exercises", "Add Exercise"][section]
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    case indexPath.section
    when EXERCISE_SECTION_INDEX
      cell = tableView.dequeueReusableCellWithIdentifier(EXERCISE_CELL_IDENTIFIER)
      exercise = @exercises[indexPath.row]

      cell.exerciseName.text = exercise.exerciseType.name
      cell.setInfo.text = "150x5 155x5 160x5 160x5 160x10"

    when EXERCISE_TYPE_SECTION_INDEX
      if indexPath.row == tableView(self.view, numberOfRowsInSection:indexPath.section) - 1 # If last row
        cell = tableView.dequeueReusableCellWithIdentifier(NEW_EXERCISE_TYPE_CELL_IDENTIFIER)

        cell.newExerciseTypeInput.when(UIControlEventEditingDidEnd) do
          createExerciseTypeAndTransition(cell.newExerciseTypeInput.text)
        end
      else
        cell = tableView.dequeueReusableCellWithIdentifier(EXERCISE_TYPE_CELL_IDENTIFIER)

        exerciseType = @exerciseTypes[indexPath.row]
        cell.exerciseName.text = exerciseType.name
      end
    end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    case indexPath.section
    when EXERCISE_SECTION_INDEX
      exercise = @exercises[indexPath.row]
      pushSetsViewController(exercise)
    when EXERCISE_TYPE_SECTION_INDEX
      return if indexPath.row == tableView(self.view, numberOfRowsInSection:indexPath.section) - 1 # If last row

      exerciseType = @exerciseTypes[indexPath.row]
      createExerciseAndTransition(exerciseType)
    end

    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    true
  end


  ## Templating ##

  class ExerciseTableViewCell < UITableViewCell
    include Teacup::Layout
    stylesheet :main
    attr_accessor :exerciseName, :setInfo

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super

      layout self.contentView do
        self.exerciseName = subview(UILabel, :exercise_name)
        self.setInfo = subview(UILabel, :set_info)
      end

      auto self.contentView do
        vertical "|[exercise_name]-[set_info]|"
        horizontal "|-[exercise_name]-|"
        horizontal "|-[set_info]-|"
      end

      self
    end
  end

  class NewExerciseTypeTableViewCell < UITableViewCell
    include Teacup::Layout
    stylesheet :main
    attr_accessor :newExerciseTypeInput

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super

      layout self.contentView do
        self.newExerciseTypeInput = subview(UITextField, :new_exercise_type_input)
      end

      self
    end
  end

  class ExerciseTypeTableViewCell < UITableViewCell
    include Teacup::Layout
    stylesheet :main
    attr_accessor :exerciseName

    def initWithStyle(style, reuseIdentifier:reuseIdentifier)
      super

      layout self.contentView do
        self.exerciseName = subview(UILabel, :exercise_type_name)
      end

      self
    end
  end
end
