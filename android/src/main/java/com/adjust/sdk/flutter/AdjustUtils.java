//
//  AdjustUtils.java
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 5th May 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

package com.adjust.sdk.flutter;

import java.text.NumberFormat;
import java.text.ParsePosition;

public class AdjustUtils {
    private static NumberFormat numberFormat = NumberFormat.getInstance();

    public static boolean stringIsNumber(String numberString) {
        if (numberString == null) {
            return false;
        }
        if (numberString.length() == 0) {
            return false;
        }

        ParsePosition position = new ParsePosition(0);
        numberFormat.parse(numberString, position);
        return numberString.length() == position.getIndex();
    }
}
