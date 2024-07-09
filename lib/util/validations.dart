library validation;

import 'package:flutter/services.dart';

const alphabets = "^[A-Za-z]+";
const numbers = "^[0-9+]+";
const alphabetSpace = "^[A-Za-z ]+";
const alphabetSpaceComma = "^[A-Za-z, ]+";
const alphaNumeric = "^[A-Za-z0-9]+";
const alphaNumericSpace = "^[A-Za-z0-9 ]+";
const alphaNumSpaceSpecial = "^[A-Za-z0-9-/,#:.() ]+";
const relationAllowedChars = "^[A-Za-z- ]+";
const alphabetsSpaceDot = "^[a-zA-Z.\ ]+";
const alphabetSpaceCommaBack = "^[a-zA-Z,\ ]+";
const phnNumbers = "^[0-9+-]+";
const passportAndVisaRegExp = "^[A-Za-z0-9-/()]+";
const dobFirstDate = 130;
const passportVisaFirstDate = 100;
const passportVisaLastDate = 100;
const passwordRegExp =
    "^[(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[@#\$*]).{8,}']+";
const userNameRegExp = "^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+){8,20}+";
