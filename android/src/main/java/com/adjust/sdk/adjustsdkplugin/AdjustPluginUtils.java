package com.adjust.sdk.adjustsdkplugin;

import java.text.NumberFormat;
import java.text.ParsePosition;

/**
 * com.adjust.sdk.adjustsdkplugin
 * Created by 2beens on 05.05.18.
 */
public class AdjustPluginUtils {
    private static NumberFormat numberFormat = NumberFormat.getInstance();

    public static boolean stringIsNumber(String numberString) {
        if(numberString == null)
            return false;

        if(numberString.length() == 0)
            return false;

        ParsePosition pos = new ParsePosition(0);
        numberFormat.parse(numberString, pos);

        return numberString.length() == pos.getIndex();
    }
}
