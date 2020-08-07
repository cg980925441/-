#include <stdio.h>
#include <windows.h>

volatile int v = 0;

// 使用x86的cas指令cmpxchg
BOOL cmpxchgIncrement(int* i) {
	int ori = *i;
	int dest = (*i)++;
	int finalVal = -1;
	_asm {
		pushad
		pushf
		mov ecx,dest
		mov eax,ori
		mov edx,i
		cmpxchg [edx],ecx
		mov finalVal,eax
		popf
		popad
	}
	// 失败了
	if (finalVal == ori) {
		return FALSE;
	}
	else {
		printf("%d,%d\n", finalVal, ori);
	}
	return TRUE;
}

void casIncrement(int* i) {
	//自旋，耗费CPU时间空转
	while (!cmpxchgIncrement(i)) {}
}

DWORD testTheadCAS(LPVOID lpThreadParameter) {
	for (int i = 0; i < 10000;i++) {
		casIncrement(&v);
	}
}

DWORD testTheadNormal(LPVOID lpThreadParameter) {
	//自增
	for (int i = 0; i < 100000; i++) {
		v++;
	}
}

int main()
{
	printf("原始值：%d\n",v);
	int threadCount = 10;
	for (int i = 0;i < threadCount;i++)
	{
		// 开线程模拟并发场景
		CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)testTheadCAS,NULL, NULL, NULL);
	}
	
	//等线程执行完
	Sleep(10000);
	printf("执行完成之后的值：%d\n", v);
	getchar();
	return 0;
}
