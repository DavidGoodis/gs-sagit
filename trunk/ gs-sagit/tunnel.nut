//--------------------
class	MobileElevator
//--------------------
{
/*<
	<Parameter =
		<speed = <Name = "Speed"> <Type = "float"> <Default = 1.0>>
	>
>*/
		speed 				=	Mtrs(1.0)
		course_height		=	Mtr(5.0)
		pos_start			=	0
		pos					=	0
		scene				=	0
		elevator_trigger	=	0
 
		player_script		=	0
		player_body			=	0

		constraints			=	0
		constraints_created	= false
		constraints_enabled	= false
		player_is_in		=	false
		constraints_timeout	=	0

		enabled			=	false
		going_up		=	true

		function	CreateConstraints(item)
		{
			print("MobileElevator::CreateConstraints(item)")
			constraints = []
			constraints.append(SceneAddPointConstraint(scene, "const0", player_body, item, Vector(0, -1.5, 0), Vector(0, 0.75, 0)))
			constraints.append(SceneAddPointConstraint(scene, "const1", player_body, item, Vector(0, 3, 0), Vector(0, 5.5, 0)))
			constraints_created	= true
			constraints_enabled = true
		}

		function	DisableConstraints(item)
		{
			ConstraintEnable(constraints[0], false)
			ConstraintEnable(constraints[1], false)
			constraints_enabled = false
		}

		function	EnableConstraints(item)
		{
			ConstraintEnable(constraints[0], true)
			ConstraintEnable(constraints[1], true)
			constraints_enabled = true
		}

		function	OnSetup(item)
		{
			pos_start = ItemGetPosition(item) //ItemGetWorldPosition(item)

			scene = ItemGetScene(item)
			elevator_trigger = ItemCastToTrigger(ItemGetChild(item, "elevator_trigger"))

			//	Get height course if possible
			local	_parent = ItemGetParent(item)
			if (ObjectIsValid(_parent))
			{
				_parent = ItemGetChild(_parent, "max_position")
				if (ObjectIsValid(_parent))
					course_height = ItemGetPosition(_parent).y - pos_start.y
			}

			pos = pos_start
			going_up = true
			constraints_created	= false
			constraints_enabled	= false
			constraints_timeout	=	g_clock
			player_is_in	=	false
		}

		function	OnUpdate(item)
		{
			ItemSetPosition(item, pos)
			ItemSetPhysicPosition(item, pos)

			if (player_body == 0)
			{
				try	//	So that the script can work outside a level
				{
					player_script = SceneGetScriptInstance(scene).player_script
					player_body = player_script.body
				}
				catch(e)
				{
					player_body = 0
					enabled = true
				}
			}
			else
			{
				if (TriggerTestItem(elevator_trigger, player_body))
				{
					player_is_in = true
					enabled = true					
				}
				else
					player_is_in = false
					
				if (!constraints_created)
				{
					CreateConstraints(item)
					DisableConstraints(item)
				}
				else
				{
					if ((g_clock - constraints_timeout) > SecToTick(Sec(0.25)))
					{
						if (player_is_in)
						{
							if (!constraints_enabled)
							{
								EnableConstraints(item)
								constraints_timeout = g_clock
							}
						}

						if (player_script.thrusters_active)
						{
							if (constraints_enabled)
							{
								DisableConstraints(item)
								constraints_timeout = g_clock
							}
						}
					}
				}
			}				

			if (!enabled)
				return

			local	_vel = Vector(0,1,0)
			_vel = _vel.Scale(g_dt_frame * (going_up?1.0:-1.0) * speed)

			pos += _vel

			if ((pos.y - pos_start.y) >= course_height)
			{
				pos.y =  pos_start.y + course_height
				going_up = false
			}
			else
			{
				if (pos.y < pos_start.y)
				{
					pos.y = pos_start.y
					going_up = true
				}
			}
		}
}
