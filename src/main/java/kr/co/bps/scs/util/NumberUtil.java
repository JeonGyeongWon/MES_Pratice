package kr.co.bps.scs.util;

import java.math.BigDecimal;
import java.math.BigInteger;

public class NumberUtil {

	public static BigDecimal getBigDecimal(Object value) {

		BigDecimal result = null;

		try {
			result = new BigDecimal(value.toString());

		} catch (Exception e) {
			result = new BigDecimal("0");
		}

		return result;
	}

	public static BigInteger getBigInteger(Object value) {

		BigInteger result = null;

		try {
			result = new BigInteger(value.toString());

		} catch (Exception e) {
			result = new BigInteger("0");
		}

		return result;
	}

	public static Integer getInteger(Object value) {

		Integer result = null;

		try {
			result = new Integer(value.toString());

		} catch (Exception e) {
			result = new Integer("0");
		}

		return result;
	}

	public static Integer getIntegerOrNull(Object value) {

		Integer result = null;

		try {
			result = new Integer(value.toString());

		} catch (Exception e) {
			result = null;
		}

		return result;
	}
}