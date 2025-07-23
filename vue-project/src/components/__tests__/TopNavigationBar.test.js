import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import TopNavigationBar from '../TopNavigationBar.vue'

describe('TopNavigationBar', () => {
  it('renders properly', () => {
    const wrapper = mount(TopNavigationBar)
    expect(wrapper.exists()).toBe(true)
  })

  it('has navigation elements', () => {
    const wrapper = mount(TopNavigationBar)
    expect(wrapper.find('nav').exists()).toBe(true)
  })
}) 