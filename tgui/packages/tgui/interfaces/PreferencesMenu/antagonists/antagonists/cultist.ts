import { Antagonist, Category } from "../base";
import { multiline } from "common/string";

export const CULTIST_MECHANICAL_DESCRIPTION
   = multiline`
      Conspire with other blood cultists to convert other crew and take over the station.
      Track down your sacrifice target, kill them via ritual, then begin to summon Nar-Sie.
      Defend her crystals until she is ready, and witness her glory tear into our dimension.
   `;


const Cultist: Antagonist = {
  key: "cultist",
  name: "Cultist",
  description: [
    multiline`
      It begins as a pulsing of your veins. The blood quickens, then grows bright and then dark.
      You will kill in the name of the Geometer, but you will also beckon more into her crimson flock.
      Most of all, you will see her returned beyond the Veil. Here, it is weakened. Now, you will act.
    `,
    CULTIST_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default Cultist;
