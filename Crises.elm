module Crises exposing (allCrises, crisisGenerator, fallbackCrisis)

import Random
import Random.List
import Types exposing (..)


s =
    10


m =
    20


l =
    30


gameOver =
    OK
        [ ( Lose, 9999999, Pop )
        ]


crisisGenerator : Random.Generator ( Maybe Crisis, List Crisis )
crisisGenerator =
    Random.List.choose allCrises


allCrises : List Crisis
allCrises =
    [ theTribute
    , cheapLabor
    , strongwoman
    , enginePodRupture
    ]


fallbackCrisis =
    { title = "FALLBACK CRISIS"
    , body =
        { description = "I SHOULD NOT BE"
        , action = OK [ ( Lose, 420, Pop ) ]
        }
    }


enginePodRupture : Crisis
enginePodRupture =
    { title = "Engine Pod Rupture"
    , body =
        { description = """
After completing the latest hyper-jump, the command bridge shutters as a tremendous BOOM! echoes through the ship's plasteel halls. Your chief engineering officer informs you that engine pod delta-alpha has violently ruptured. Within moments you learn that hundreds have perished in the initial explosion and several fires have trapped the surviving machinists in the ravaged pod.

You could order the pod jettisoned from the ship, dooming the survivors but preventing the fires from spreading to the ship's food stores. The Forge urges you to send a team in to rescue the trapped machinists – their knowledge and skills are irreplaceable, and if a thousand useless civilians must starve to death to save even a single machinist, then that is a small price to pay. Only the Shield can provide a team skilled enough to attempt a rescue mission, though they insist it would be a suicide mission.
      """
        , action =
            Choices
                [ { name = "Jettison the burning engine pod, dooming the survivors."
                  , consequence =
                        { description = "Your food stores are safe, but many irreplaceable machinists have been lost. The Forge is greatly displeased."
                        , action = OK [ ( Lose, m, Pop ), ( Lose, s, ForgeAff ) ]
                        }
                  }
                , { name = "Order a crisis response team to attempt a rescue mission. (low shield affinity)"
                  , consequence =
                        { description = "The Shield-led rescue team has made contact with the survivors, but the fires have spread faster than expected, and now the rescue team is trapped too!"
                        , action =
                            Choices
                                [ { name = "Send in a second rescue team to rescue the first rescue team!"
                                  , consequence =
                                        { description = "You order in a second rescue team, but no sooner do they enter the pod than it explodes! This is a complete disaster!"
                                        , action =
                                            OK
                                                [ ( Lose, l, Pop )
                                                , ( Lose, l, ForgeAff )
                                                , ( Lose, l, ShieldAff )
                                                , ( Lose, l, BellyAff )
                                                ]
                                        }
                                  }
                                , { name = "Cut our losses. Jettison the pod!"
                                  , consequence =
                                        { description = "The rest of the ship is spared, but both the Forge and the Shield are angry at your bungling of the crisis."
                                        , action =
                                            OK
                                                [ ( Lose, l, Pop )
                                                , ( Lose, m, ForgeAff )
                                                , ( Lose, s, ShieldAff )
                                                ]
                                        }
                                  }
                                ]
                        }
                  }
                , { name = "Order a crisis response team to attempt a rescue mission. (high shield affinity)"
                  , consequence =
                        { description = "As the Shield-led rescue team ushers the last machinist out of the pod,        the entire structure begins to collapse. To prevent damage to the rest of the ship, the rescue team manually jettisons the pod, bravely sacrificing themselves to save countless lives."
                        , action =
                            OK
                                [ ( Lose, l, Pop )
                                , ( Gain, m, ForgeAff )
                                , ( Gain, m, BellyAff )
                                , ( Lose, m, ShieldAff )
                                ]
                        }
                  }
                ]
        }
    }


strongwoman : Crisis
strongwoman =
    { title = "Strongwoman"
    , body =
        { description = """
A military rival has emerged to challenge your position as Admiral. While she has not yet directly disobeyed orders, she has decried you privately to your other officers in an attempt to undermine your authority. Clearly, she desires to steal the Admiral's Throne from you. How will you deal with her?
      """
        , action =
            Choices
                [ { name = "Order your most trusted bodyguards to summarily execute the treacherous officer. (low shield affinity)"
                  , consequence =
                        { description = "You lead your bodyguards to the traitor's quarters, but when you order them    to execute her, they hesitate. The traitor gives them a simple nod, and one of them steps forward and place the muzzle of his sidearm to your forehead. “Sic semper tyrannis” he says before pulling the trigger. You have died!"
                        , action = gameOver
                        }
                  }
                , { name = "Order your most trusted bodyguards to summarily execute the treacherous officer. (high shield affinity)"
                  , consequence =
                        { description = "The pretender is dead, yet demonstrations have erupted throughout the ship protesting your abuse of power."
                        , action =
                            OK
                                [ ( Gain, m, ShieldAff )
                                , ( Lose, m, BellyAff )
                                , ( Lose, m, ShieldAff )
                                , ( Lose, m, WayAff )
                                , ( Lose, m, GardenAff )
                                , ( Lose, m, PickAff )
                                , ( Lose, m, MutexAff )
                                , ( Lose, m, BrainsAff )
                                , ( Lose, m, ForgeAff )
                                ]
                        }
                  }
                , { name = "Have the treacherous officer tried for insubordination at a military tribunal. (low shield affinity)"
                  , consequence =
                        { description = "Your attempt to have the pretender removed via official channels has backfired! She has been found not guilty – this is a tremendous embarrassment!"
                        , action =
                            OK
                                [ ( Lose, l, ShieldAff )
                                , ( Lose, s, BellyAff )
                                , ( Lose, s, WayAff )
                                , ( Lose, s, GardenAff )
                                , ( Lose, s, PickAff )
                                , ( Lose, s, MutexAff )
                                , ( Lose, s, BrainsAff )
                                , ( Lose, s, ForgeAff )
                                ]
                        }
                  }
                , { name = "Have the treacherous officer tried for insubordination at a military tribunal. (high shield affinity)"
                  , consequence =
                        { description = "The treacherous officer is brought before trial and, as expected, found guilty. Rather than allow her to suffer the humiliation of the firing squad, you generously allow her to take her own life. And they say the system doesn't work!"
                        , action =
                            OK
                                [ ( Gain, s, ShieldAff )
                                ]
                        }
                  }
                ]
        }

    -- "Keep your enemies closer" choices
    }


cheapLabor : Crisis
cheapLabor =
    { title = "Cheap Labor"
    , body =
        { description = """
While passing a barren desert world, your scanners have revealed a significant alien population. Further investigation reveals a series of natural disasters has left much of the population destitute and out of work. After tentatively establishing communication with the aliens, they offer to perform dangerous manual labor for you in exchange for nothing more than room and board.

The Garden asks permission to hire the aliens – with cheap labor, they can lower food production costs. The Forge also desires the alien workers to turn into lobotomized cyborg production-line workers. Sympathetic groups within the Belly ask that you provide the aliens with food but do not bring them onboard. The Pick, meanwhile, warns that will violently oppose any attempts to give jobs to the “scab species.”
      """
        , action =
            Choices
                [ { name = "Leave the aliens behind without further action."
                  , consequence =
                        { description = "Out of sight, out of mind."
                        , action =
                            OK
                                [ ( Gain, s, PickAff )
                                , ( Lose, s, ForgeAff )
                                , ( Lose, s, GardenAff )
                                , ( Lose, s, BellyAff )
                                ]
                        }
                  }
                , { name = "Hand the aliens over to the Garden."
                  , consequence =
                        { description = "The aliens are put to work harvesting the latest crop of Gene-Burgers, though  violent clashes between laid-off humans and Garden security forces are now a daily occurrence."
                        , action =
                            OK
                                [ ( Gain, m, GardenAff )
                                , ( Lose, m, PickAff )
                                , ( Lose, s, ForgeAff )
                                , ( Lose, s, BellyAff )
                                , ( Gain, s, Food )
                                , ( Gain, s, Pop )
                                ]
                        }
                  }
                , { name = "Hand the aliens over to the Forge."
                  , consequence =
                        { description = "The aliens are quickly lobotomized and put to work maintaining the ship's generators, though violent clashes between laid-off humans and Forge security forces are now a daily occurrence."
                        , action =
                            OK
                                [ ( Gain, m, ForgeAff )
                                , ( Lose, m, PickAff )
                                , ( Lose, s, GardenAff )
                                , ( Lose, s, BellyAff )
                                , ( Gain, s, Fuel )
                                , ( Gain, s, Pop )
                                ]
                        }
                  }
                , { name = "Give the aliens enough food to keep them alive but do not take them aboard."
                  , consequence =
                        { description = "Crates of frozen space soup are fired via food-cannon at the aliens' population centers. An assistant points out that the aliens will now likely descend into civil war over the precious food, but you're too busy patting yourself on the back to listen."
                        , action =
                            OK
                                [ ( Gain, s, BellyAff )
                                , ( Gain, s, PickAff )
                                , ( Lose, s, ForgeAff )
                                , ( Lose, s, GardenAff )
                                , ( Lose, m, Food )
                                ]
                        }
                  }
                ]
        }
    }


theTribute : Crisis
theTribute =
    { title = "The Tribute"
    , body =
        { description = """
You complete the latest hyper-jump and find yourself face-to-face with a massive alien battleship. Ten thousand rail-cannons crackle with plasma energy, ready to unleash the destructive force of a supernova upon your ship. Your comms-screen lights up, revealing the snarling face of an alien warlord. The warlord introduces himself as Zlaxx the Orphan-Maker and demands that you pay him tribute. In exchange for a large sum of goods, he will allow you to carry on your journey. If you deny him tribute, he promises to erase your ship from existence.
    """
        , action =
            Choices
                [ { name = "Offer him a king's feast."
                  , consequence =
                        { description = "Zlaxx accepts your tribute and departs."
                        , action =
                            OK
                                [ ( Lose, l, Food )
                                ]
                        }
                  }
                , { name = "Offer him precious fuel."
                  , consequence =
                        { description = "Zlaxx accepts your tribute and departs."
                        , action =
                            OK
                                [ ( Lose, l, Fuel )
                                ]
                        }
                  }
                , { name = "Offer him human slaves."
                  , consequence =
                        { description = """Zlaxx accepts your tribute and departs. You turn to your officers and advisers. They glare at you. "What'd I do?" you ask innocently."""
                        , action =
                            OK
                                [ ( Lose, m, Pop )
                                , ( Lose, m, ShieldAff )
                                , ( Lose, m, BellyAff )
                                , ( Lose, m, WayAff )
                                , ( Lose, m, GardenAff )
                                , ( Lose, m, PickAff )
                                , ( Lose, m, MutexAff )
                                , ( Lose, m, BrainsAff )
                                , ( Lose, m, ForgeAff )
                                ]
                        }
                  }
                , { name = "Offer him mysterious spice."
                  , consequence =
                        { description = "Zlaxx accepts your tribute and departs."
                        , action =
                            OK
                                [ ( Lose, m, Spice )
                                ]
                        }
                  }

                --, { name = """Pull down your pants, wave your butt in Zlaxx's face, then spank your own butt and proclaim, "I've got your tribute right here, buddy boy!" """
                --  , consequence =
                --        { description = "Zlaxx responds by vaporizing your ship and all human life aboard."
                --        , action = gameOver
                --        }
                --  }
                -- and double-cross
                ]
        }
    }
