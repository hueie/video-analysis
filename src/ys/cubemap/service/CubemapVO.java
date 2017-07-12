package kams.ys.cubemap.service;

import kams.common.paging.PagingVO;

public class CubemapVO extends PagingVO {
	String stack_id;
	String cubes;

	public String getStack_id() {
		return stack_id;
	}

	public void setStack_id(String stack_id) {
		this.stack_id = stack_id;
	}

	public String getCubes() {
		return cubes;
	}

	public void setCubes(String cubes) {
		this.cubes = cubes;
	}
}
