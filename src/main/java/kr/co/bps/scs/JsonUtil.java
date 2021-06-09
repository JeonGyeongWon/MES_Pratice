package kr.co.bps.scs;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;

/**
 * Created by ymha on 18. 05. 24.
 */
public class JsonUtil {
	private static final Log log = LogFactory.getLog(JsonUtil.class);

	/**
	 * 2차원 배열의 부모-자식 관계의 데이터를 트리 형식으로 변형
	 * 
	 * @param list - 2차원 목록
	 * @param rootno - 최상위 번호
	 * @param childno - 하위번호
	 * @param parentno - 상위번호
	 * @param childname - 하위명
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<Map<String, Object>> treeMap(final List<Map<String, Object>> inList, String rootno, final String childno, final String parentno) {
		List<Map<String, Object>> treeList = new ArrayList<Map<String, Object>>();
		System.out.println("treeMap Method Start. >>>>>>>>>>");

		if (inList == null || inList.size() == 0)
			throw new RuntimeException("List<Map> 데이터가 없습니다.");
		if (inList.get(0) == null)
			throw new RuntimeException("Map 데이터가 없습니다.");

		// LIST Null 처리
		for (int i = 0; i < inList.size(); i++) {
			Map<String, Object> cur = (Map<String, Object>) inList.get(i);
			Set set = cur.entrySet();

			Iterator ite = set.iterator();
			while (ite.hasNext()) {
				Map.Entry ent = (Map.Entry) ite.next();
				cur.put((String) ent.getKey(), (ent.getValue() == null) ? "" : ent.getValue());
			}
		}

		final List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Iterator iter;
		for (iter = inList.iterator(); iter.hasNext();) {
			try {
				Object obj = iter.next();
				
				if (obj instanceof Map) {
					list.add((Map<String, Object>) obj);
				} else {
					list.addAll((Collection<? extends Map<String, Object>>) BeanUtils.describe(obj));
				}
			} catch (Exception e) {
				throw new RuntimeException("Collection -> List<Map> 으로 변환 중 실패 >>>>>>>>>> " + e);
			}
		}

		try {
			int listLength = list.size();
			int loopLength = 0;
			final int[] treeLength = new int[] { 0 };
			while (treeLength[0] != listLength && listLength != loopLength++) {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> item = list.get(i);
					
					boolean operate1 = rootno.equals( StringUtil.nullConvert(item.get(parentno)) );
					if (operate1) {
						Map<String, Object> view = new HashMap<String, Object>(item);
						view.putAll(item);
						view.put("children", new ArrayList<Map<String, Object>>());

						boolean isChk = (NumberUtil.getInteger(item.get("COUNT")) > 0);
						if (isChk) {
							// 트리 확장이벤트 생성
							view.put("expanded", true);
							view.put("iconCls", "folder");
						} else {
							// 최종 하위노드 생성
							view.put("leaf", true);
							view.put("iconCls", "file");
						}
						treeList.add(view);
						list.remove(i);

						treeLength[0]++;

						break;
					} else {
						new InnerClass() {
							public void getParentNode(List<Map<String, Object>> children, Map<String, Object> item) {
								for (int i = 0; i < children.size() ; i++) {
									Map<String, Object> child = children.get(i);

									String cno = StringUtil.nullConvert(child.get(childno));
									String pno = StringUtil.nullConvert(item.get(parentno));
									boolean operate2 = cno.equals( pno );
									if (operate2) {
										Map<String, Object> view = new HashMap<String, Object>(item);
										view.putAll(item);
										view.put("children", new ArrayList<Map<String, Object>>());

										boolean isChk = (NumberUtil.getInteger(item.get("COUNT")) > 0);
										if (isChk) {
											// 트리 확장이벤트 생성
											view.put("expanded", true);
											view.put("iconCls", "folder");
										} else {
											// 최종 하위노드 생성
											view.put("leaf", true);
											view.put("iconCls", "file");
										}
										((List<Map<String, Object>>) child.get("children")).add(view);
										list.remove(list.indexOf(item));
										
										treeLength[0]++;

										break;
									} else {
										if (((List<Map<String, Object>>) child.get("children")).size() > 0) {
											getParentNode((List<Map<String, Object>>) child.get("children"), item);
										}
									}
								}
							}
						}.getParentNode(treeList, item);
					}
				}
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return treeList;
	}

	/**
	 * 2차원 배열의 부모-자식 관계의 데이터를 트리 형식으로 변형 (정렬기준 추가 - 오름차순)
	 * 
	 * @param list - 2차원 목록
	 * @param rootno - 최상위 번호
	 * @param childno - 하위번호
	 * @param parentno - 상위번호
	 * @param childname - 하위명
	 * @param orderno - 정렬항목명
	 * @return
	 */
	public static List<Map<String, Object>> treeMap(List inList, String rootno, final String childno, final String parentno, final String orderno) {
		List<Map<String, Object>> treeList = new ArrayList<Map<String, Object>>();
		System.out.println("treeMap Method Start. >>>>>>>>>>");

		if (inList == null || inList.size() == 0)
			throw new RuntimeException("List<Map> 데이터가 없습니다.");
		if (inList.get(0) == null)
			throw new RuntimeException("Map 데이터가 없습니다.");

		// LIST Null 처리
		for (int i = 0; i < inList.size(); i++) {
			Map<String, Object> cur = (Map<String, Object>) inList.get(i);
			Set set = cur.entrySet();

			Iterator ite = set.iterator();
			while (ite.hasNext()) {
				Map.Entry ent = (Map.Entry) ite.next();
				cur.put((String) ent.getKey(), (ent.getValue() == null) ? "" : ent.getValue());
			}
		}

		final List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Iterator iter;
		for (iter = inList.iterator(); iter.hasNext();) {
			try {
				Object obj = iter.next();
				if (obj instanceof Map) {
					list.add((Map<String, Object>) obj);
				} else {
					list.addAll((Collection<? extends Map<String, Object>>) BeanUtils.describe(obj));
				}
			} catch (Exception e) {
				throw new RuntimeException("Collection -> List<Map> 으로 변환 중 실패 >>>>>>>>>> " + e);
			}
		}

		try {
			int listLength = list.size();
			int loopLength = 0;
			final int[] treeLength = new int[] { 0 };
			while (treeLength[0] != listLength && listLength != loopLength++) {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> item = list.get(i);
					
					boolean operate1 = rootno.equals( StringUtil.nullConvert(item.get(parentno)) );
					if (operate1) {
						Map<String, Object> view = new HashMap<String, Object>(item);
						view.putAll(item);
						view.put("children", new ArrayList<Map<String, Object>>());

//						view.put("isFolder", "true");
						boolean isChk = (NumberUtil.getInteger(item.get("COUNT")) > 0);
						if (isChk) {
							// 트리 확장이벤트 생성
							view.put("expanded", true);
							view.put("iconCls", "folder");
						} else {
							// 최종 하위노드 생성
							view.put("leaf", true);
							view.put("iconCls", "file");
						}
						treeList.add(view);
						list.remove(i);

						treeLength[0]++;

						if (orderno != null) {
							Collections.sort(treeList, new Comparator<Map<String, Object>>() {
								public int compare(Map<String, Object> arg0, Map<String, Object> arg1) {
									// TODO 컬렉션 정렬기능으로 순차정렬
					                return ((Comparable) arg0.get(orderno)).compareTo(arg1.get(orderno));
								}
							});
						}
						break;
					} else {
						new InnerClass() {
							public void getParentNode(List<Map<String, Object>> children, Map<String, Object> item) {
								for (int i = 0; i < children.size() ; i++) {
									Map<String, Object> child = children.get(i);

									String cno = StringUtil.nullConvert(child.get(childno));
									String pno = StringUtil.nullConvert(item.get(parentno));
									boolean operate2 = cno.equals( pno );
									if (operate2) {
										Map<String, Object> view = new HashMap<String, Object>(item);
										view.putAll(item);
										view.put("children", new ArrayList<Map<String, Object>>());

//										view.put("isFolder", "true");
										boolean isChk = (NumberUtil.getInteger(item.get("COUNT")) > 0);
										if (isChk) {
											// 트리 확장이벤트 생성
											view.put("expanded", true);
											view.put("iconCls", "folder");
										} else {
											// 최종 하위노드 생성
											view.put("leaf", true);
											view.put("iconCls", "file");
										}
										((List<Map<String, Object>>) child.get("children")).add(view);

										treeLength[0]++;

										list.remove(list.indexOf(item));

										if (orderno != null) {
											Collections.sort(((List<Map<String, Object>>) child.get("children")), new Comparator<Map<String, Object>>() {
												public int compare(Map<String, Object> arg0, Map<String, Object> arg1) {
													// TODO 컬렉션 정렬기능으로 순차정렬
									                return ((Comparable) arg0.get(orderno)).compareTo(arg1.get(orderno));
												}
											});
										}
										break;
									} else {
										if (((List<Map<String, Object>>) child.get("children")).size() > 0) {
											getParentNode((List<Map<String, Object>>) child.get("children"), item);
										}
									}
								}
							}
						}.getParentNode(treeList, item);
					}
				}
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return treeList;
	}

	public interface InnerClass {
		public void getParentNode(List<Map<String, Object>> list, Map<String, Object> item);
	}

}