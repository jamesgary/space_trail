module Crises exposing (crisisGenerator, fallbackCrisis)

import Random
import Random.List
import Types exposing (..)


crisisGenerator : Random.Generator ( Maybe Crisis, List Crisis )
crisisGenerator =
    Random.List.choose allCrises


allCrises : List Crisis
allCrises =
    [ { title = "Heat Death"
      , description =
            """
        You awake one morning-cycle and find you can see your own breath. "We have a problem," your assistant informs you before you can even finish inserting your caffeine suppository. It seems the ship's temperature regulation systems are failing. The entire ship is losing heat and several populated sections of the ship are already freezing cold and getting colder. The Skillicus Machinicus assures you that the systems can be fixed - but not before people have died. Your navigator suggests that they move off-course and closer to the nearest star in order to warm the ship up while the engineers fix the systems – it will cost precious fuel but save lives. The Pickax proxy suggests disassembling some of your robots and using their batteries to power heating devices. What should we do?
        """
      , choices =
            [ { name = "Repair System"
              , consequence =
                    Branch
                        { title = "Heat Death: Conclusion"
                        , description = "You managed to repair the systems, but not before several casualties."
                        , choices = [ { name = "OK", consequence = Leaf [ ( Lose, 10, Pop ) ] } ]
                        }
              }
            , { name = "Approach Star"
              , consequence = Leaf [ ( Lose, 20, Fuel ) ]
              }
            , { name = "Harvest batteries"
              , consequence = Leaf [ ( Lose, 30, Robot ) ]
              }
            ]
      }
    , { title = "Engine Pod Rupture"
      , description = """
      After completing the latest hyper-jump, the command bridge shutters as a tremendous BOOM! echoes through the ship's plasteel halls. Your chief engineering officer informs you that engine pod delta-alpha has violently ruptured. Within moments you learn that hundreds have perished in the initial explosion and several fires have trapped the surviving machinists in the ravaged pod.

      You could order the pod jettisoned from the ship, dooming the survivors but preventing the fires from spreading to the ship's food stores. The Forge urges you to send a team in to rescue the trapped machinists – their knowledge and skills are irreplaceable, and if a thousand useless civilians must starve to death to save even a single machinist, then that is a small price to pay. Only the Shield can provide a team skilled enough to attempt a rescue mission, though they insist it would be a suicide mission.
      """
      , choices =
            [ { name = "Jettison the burning engine pod, dooming the survivors."
              , consequence =
                    Branch
                        { title = "Engine Pod Rupture"
                        , description = "Your food stores are safe, but many irreplaceable machinists have been lost. The Forge is greatly displeased."
                        , choices = [ { name = "OK", consequence = Leaf [ ( Lose, 20, Pop ) ] } ]
                        }
              }
            ]
      }
    ]


fallbackCrisis =
    { title = "FALLBACK CRISIS"
    , description = "I SHOULD NOT BE"
    , choices =
        [ { name = "OH SNAP"
          , consequence = Leaf [ ( Lose, 420, Pop ) ]
          }
        ]
    }
