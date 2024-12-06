/**
 * @author Raining
 * @date 2024-12-06 14:27
 *
 * #I# Widget测试
 */
class Demo2 {
  // 将状态更新逻辑封装在一个方法中，可以确保状态的更新是原子性的。当setState被调用时，Flutter框架会确保在状态更新和UI重建之间不会发生其他状态更改。
  // 如果有多个setState调用在短时间内发生，它们可能会被合并为一个UI更新。
  // setState的参数方法回调是在你调用setState时立即执行的，但UI的更新会在未来的某个时间点发生，这取决于Flutter框架的事件循环和渲染管道。
}
